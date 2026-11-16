"""Render every Compose template and check project/volume isolation; starts nothing."""

import argparse
import json
import os
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compose-binary", help="Standalone Compose executable")
    args = parser.parse_args()
    command = [args.compose_binary] if args.compose_binary else ["docker", "compose"]
    root = Path(__file__).resolve().parents[1]
    templates = sorted((root / "deployments").rglob("compose.yml"))
    if not templates:
        raise SystemExit("No Compose templates found")

    # Use only committed example values, regardless of the caller's Compose setup.
    env = {key: value for key, value in os.environ.items()
           if not key.startswith(("COMPOSE_", "GF_ADMIN_"))}
    project_names = set()
    volume_names = set()

    def render(template, project=None):
        options = ["--env-file", str(template.with_name(".env.example")),
                   "-f", str(template)]
        if project:
            options += ["-p", project]
        result = subprocess.run(command + options + ["config", "--format", "json"],
                                env=env, check=True, stdout=subprocess.PIPE, text=True)
        return json.loads(result.stdout)

    def check(config, expected_project=None):
        name = config["name"]
        if name == "compose" or name in project_names:
            raise ValueError(f"Missing or duplicate project name: {name}")
        if expected_project and name != expected_project:
            raise ValueError(f"Project override was ignored: {name}")
        project_names.add(name)
        for service, settings in config["services"].items():
            if "container_name" in settings:
                raise ValueError(f"{name}/{service} fixes a global container name")
        for volume in config.get("volumes", {}).values():
            volume_name = volume["name"]
            if volume_name in volume_names:
                raise ValueError(f"Shared volume across projects: {volume_name}")
            volume_names.add(volume_name)

    for index, template in enumerate(templates):
        check(render(template))
        for instance in ("a", "b"):
            project = f"ci-template-{index}-{instance}"
            check(render(template, project), project)
        print(f"Validated {template.relative_to(root)} and two isolated instances")

    print(f"Passed: {len(templates)} templates, {len(project_names)} projects")


if __name__ == "__main__":
    main()
