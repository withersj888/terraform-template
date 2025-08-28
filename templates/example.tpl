# Example Module Output

This file demonstrates the module's functionality.

## Configuration
- Environment: ${environment}
- Project Name: ${project_name}
- Random ID: ${random_id}
- Advanced Features: ${enable_advanced_features}

## Custom Configuration
%{ if enable_advanced_features ~}
- Setting A: ${custom_configuration.setting_a}
- Setting B: ${custom_configuration.setting_b}
- Setting C: ${custom_configuration.setting_c}
%{ endif ~}

## Tags Applied
%{ for key, value in tags ~}
- ${key}: ${value}
%{ endfor ~}

Generated at: ${timestamp()}
