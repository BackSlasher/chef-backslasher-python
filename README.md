# backslasher-python-cookbook

A cookbook for managing python-related resources in a simple way  
This is mostly a ripoff of the [python cookbook](https://github.com/poise/python), since it's both deprecated and has its resource names stolen by [poise-python cookbook](https://github.com/poise/poise-python)  
Resources:

* `backslasher_python_pip_installer`: Makes sure a python envrionment has pip installed
* `backslasher_python_pip`: A pip package
* `backslasher_python_virtualenv`: A virtual environment

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['backslasher-python']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### backslasher-python::default

Include `backslasher-python` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[backslasher-python::default]"
  ]
}
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
