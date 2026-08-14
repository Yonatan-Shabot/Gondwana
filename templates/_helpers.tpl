{{- define "gondwana.nameSuffix" }}
{{- /* Expects $ as the only argument, this can be overridable to add preset suffix logic to any object */}}
{{- end }}
{{- define "gondwana.isOpenshift" }}
{{- /* Expects $ as the only argument, this checks whether the cluster is an OpenShift cluster */}}
{{- if (has (.Values.commons.clusterType | lower) (list "ocp", "openshift")) }}
"true"
{{- end }}
{{- end }}

{{- define "gondwana.labels" }}
{{- /* Expects $ as the only argument */}}
app.kubernetes.io/part-of: {{ .Release.Name }}
generator: "helm"
{{- end }}

{{- define "gondwana.files.getList" }}
{{- $root := .root }} {{- /* Should always be $ */}}
{{- $serviceName := .name }}
{{- range $fileToMount := .filesFrom }}
{{- $filesObject := index $root.Values.commons.globalFiles $fileToMount.name }}
- name: {{ $fileToMount.name }}
  paths:
    {{- range $path, $bytes := $root.Files.Glob (printf "%s/*" $filesObject.dir) }}
    - {{ base $path }}
    {{- end }}
    {{- if $filesObject.file }}
    - {{ base $filesObject.file }}
    {{- end }}
  mountPath: {{ $fileToMount.mountPath }}
  secret: false
  {{- /* Currently this is explicitly set to false becuase we need to false becuase files that are in the repo are not really secret, 
  this could be fixed by finding a solution that integrates with SealedSecrets */}}
{{- end }}
{{- range $fileConfig := .files }}
{{- $parsedFile := ($fileConfig.file | default "" | replace "." "-" | replace "/" "-") }} {{- /* replaces / and . with - */}}
{{- $parsedDir := (regexReplaceAll "^-" (printf "%s-" ($fileConfig.dir | default "") | replace "/" "-") "") }} {{- /* replaces / with - and suffixes a -*/}}
{{- $configFileName := (printf "%s-%s%s" $serviceName $parsedDir $parsedFile | trimSuffix "-") }}
- name: {{ $configFileName }}
  paths:
    {{- range $path, $bytes := $root.Files.Glob (printf "%s/*" $fileConfig.dir) }}
    - {{ base $path }}
    {{- end }}
    {{- if $fileConfig.file }}
    - {{ base $fileConfig.file }}
    {{- end }}
  mountPath: {{ $fileConfig.mountPath }}
  secret: false
  {{- /* Currently this is explicitly set to false becuase we need to false becuase files that are in the repo are not really secret, 
  this could be fixed by finding a solution that integrates with SealedSecrets */}}
{{- end }}
{{- end }}

{{- define "gondwana.files.createDict" }}
{{- $root := .root }} {{- /* Should be $*/}}
{{- $file := .file }} {{- /* A single file to be added, full path from repo root */}}
{{- $dir := .dir }} {{- /* A directory to be added in its entirety, full path from repo root */}}
{{- if $dir }}
{{- include "gondwana.files.createDict.dir" (dict "root" $root "dir" $dir)}}
{{- end }}
{{- if $file }}
{{- include "gondwana.files.createDict.file" (dict "root" $root "file" $file)}}
{{- end }}
{{- end }}

{{- define "gondwana.files.createDict.dir" }}
{{- $root := .root }} {{- /* Should be $*/}}
{{- $dir := .dir }} {{- /* A directory to be added in its entirety, full path from repo root */}}
{{- range $path, $bytes := $root.Files.Glob (printf "%s/*" $dir) }}
{{ base $path }}: |-
{{ $root.Files.Get $path | indent 2 }}
{{- end }}
{{- end }}

{{- define "gondwana.files.createDict.file" }}
{{- $root := .root }} {{- /* Should be $*/}}
{{- $file := .file }} {{- /* A directory to be added in its entirety, full path from repo root */}}
{{ base $file }}: |-
{{ $root.Files.Get $file | indent 2 }}
{{- end }}

{{- define "gondwana.service.image" }}
{{- $root := .root }} {{- /* Should be $*/}}
{{- $image := .image | default .serviceName }} {{- /* The image's name, if not specified will take the service's name */}}
{{- $imageTag := index $root.Values.release $image }} {{- /* getting the image's tag from the release field */}}
{{- if not (regexMatch `^.*[\.:].*\/.*` $image) }}
{{- $image := (printf "%s/%s" $root.Values.commons.imageRepo $image) }}
{{- end }}
{{- $image }}:{{ $imageTag }}
{{- end }}
