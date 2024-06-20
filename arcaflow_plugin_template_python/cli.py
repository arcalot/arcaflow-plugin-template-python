import sys
from arcaflow_plugin_sdk import plugin as plugin_sdk
import arcaflow_plugin_template_python.template_python_plugin as template_plugin


def main():
    sys.exit(
        plugin_sdk.run(
            plugin_sdk.build_schema(
                # List your step functions here:
                template_plugin.hello_world,
            )
        )
    )

if __name__ == "__main__":    
    main()