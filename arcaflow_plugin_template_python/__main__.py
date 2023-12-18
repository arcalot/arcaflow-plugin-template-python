import sys
from arcaflow_plugin_template_python import plugin
from arcaflow_plugin_template_python import hello_world

if __name__ == "__main__":
    sys.exit(
        plugin.run(
            plugin.build_schema(
                # List your step functions here:
                hello_world,
            )
        )
    )
    