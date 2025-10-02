# ArgoCd Template

## About
ArgoCd templates used in configuration file.


## Usage

To include a yaml template:
```yml
template.on-deployed-template: {{ .Files.Get "argocd-templates/on-deployed-template.yml" | quote }}
```

## Why not inline in the Helm template?

ArgoCd uses also Go templating and therefore conflict with Helm templating.

To include ArgoCd template in Helm Template, 
* we would need to print the ArgoCd template open/close characters
Example:
```yml
{{ print '{{' }}.app.metadata.name{{ print '}}' }} 
```
This directory gives you another option, include the ArgoCd template


