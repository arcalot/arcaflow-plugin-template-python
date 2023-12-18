#!/usr/bin/env python3
import unittest
import arcaflow_plugin_template_python as plugin
from arcaflow_plugin_sdk import plugin as plugin_sdk


class HelloWorldTest(unittest.TestCase):
    @staticmethod
    def test_serialization():
        plugin_sdk.test_object_serialization(plugin.InputParams("John Doe"))

        plugin_sdk.test_object_serialization(
            plugin.SuccessOutput("Hello, world!")
        )

        plugin_sdk.test_object_serialization(
            plugin.ErrorOutput(error="This is an error")
        )

    def test_functional(self):
        input = plugin.InputParams(name="Example Joe")

        output_id, output_data = plugin.hello_world(
            params=input, run_id="plugin_ci"
        )

        # The example plugin always returns an error:
        self.assertEqual("success", output_id)
        self.assertEqual(
            output_data,
            plugin.SuccessOutput("Hello, Example Joe!"),
        )


if __name__ == "__main__":
    unittest.main()
