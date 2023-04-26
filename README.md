# Read XML files and dispatch them to different processes

This example shows how to create a process that's role is to trigger other processes. In our sample case, the process read XML files from a given folder, reads a value from the first element's attribute and uses that to determine the process to trigger. The example also gives the said XML file as a input work item file to the triggered process.

This example is easy to extend for example to read different types of inputs, dispatch files to several processes or to create work item payloads instead of files.

## Setup

- You need processes to trigger, a minimum two in this example case. Use for example a simple [work item logger robot](https://github.com/tonnitommi/robocorp-log-work-item) if you don't have your own robots available yet.
- Once those processes are created in the [Control Room](https://cloud.robocorp.com), you'll need a Vault entry called `dispatch_demo` that has the following entries:
  - `workspace_id` the workspace ID of where the triggered processes are (use e.g. API Helper to find out the value)
  - `process_id_1` one process ID that will be triggered
  - `process_id_2` second process ID that will be triggered 
  - `apikey` API key that has credentials to manage processes

## Key principles

Variables section defines a dictionary that is mapping between "something" in your XML to the processes, which are represented by the names given in the Vault. It looks like this.

```robot
&{PROCESSES}            OTHER_THING=process_id_1
...                     SOME_THING=process_id_2
```

In this example case the strings `OTHER_THING` and `SOME_THING` are found from the XML files, like below.

```xml
<example>
  <first id="OTHER_THING">text</first>
  <second id="2">
    <child/>
  </second>
...
</example>
```
