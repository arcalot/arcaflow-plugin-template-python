import sys
from arcaflow_plugin_sdk import plugin
from arcaflow_plugin_template_python.plugin_template_python import hello_world



if __name__ == "__main__":
    # print(dir(arcaflow_plugin_template_python))
    sys.exit(
        plugin.run(
            plugin.build_schema(
                # List your step functions here:
                hello_world,
            )
        )
    )
