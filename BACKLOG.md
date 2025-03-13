# Crisp CLI Backlog

## Environment

Users can activate and deactivate project specific crisp environments in their shell.

### Activate Environment

**Given** a valid crisp installation
**Given** no already activated environment
**When** `source .crisp/scripts/activate.sh` is executed
**Then** Crisp commands and environmental variables are sourced into the shell

**Given** an invalid crisp installation
**When** `source .crisp/scripts/activate.sh` is executed
**Then** Crisp returns an error message reporting any known issues

**Given** an already activated environment
**When** `source .crisp/scripts/activate.sh` is executed
**Then** Crisp returns an error reporting an environment is active

### Deactivate Environment

**Given** an activated environment
**When** `source .crisp/scripts/deactivate.sh` is executed
**Then** Crisp commands and environmental variables are removed from the shell

**Given** an inactivated environment
**When** `source .crisp/scripts/deactivate.sh` is executed
**Then** Crisp returns error message reporting there is no environment to deactivate

### Status

**Given** an activated environment
**When** `crisp status` is executed
**Then** Crisp reports on the current status of the tool

> [!Question] What would be useful to get an overview of project here?
>
> - artifact counts
> - environmental variables

**Given** an inactive environment
**When** `crisp status` is executed
**Then** Crisp reports no environment active and recommends how to activate

### Validation

**Given** an activated environment
**When** `crisp validate -a` is executed
**Then** Crisp checks the entire environment/installation

> [!Question] What is a valid Crisp installation?
>
> - all environmental variable directories exist
> - script files exist
> - able to source and run none-destructive functions
> - "project specific" test?
> - index able to run? test if files exists?
> - all types have templates
> - templates are valid

**Given** an activated environment
**When** `crisp validate <path>` is executed
**Then** Crisp checks if the item is valid

**Given** an activated environment
**When** `crisp validate <artifact_path>` is executed
**Then** Crisp checks if the item is valid

> [!Question] What is a valid template?
>
> - all requested fields are available in index_cache
> - parsable by template tool

## Artifacts

### Create Artifacts

**Given** an activated environment
**When** The command `crisp add <artifact_type>` is executed
**Then** Crisp creates a new artifact in appropriate output folder
**Then** Crisp creates a new artifact using the appropirate template
**Then** Crisp creates a new artifact with a unique, none-colliding id
**Then** The appropriate indexes are updated

**Given** an activated environment
**When** The command `crisp add <malformed_type>` is executed
**Then** Crisp returns an error and reports possible artifact types

**Given** an inactive environment
**When** The command `crisp add <artifact_type>` is executed
**Then** Crisp returns an error and reports no environment is active

### Artifact Parsing

Extract information from each file, primarily, frontmatter, body summary,
and any other fields idendified that could be useful.

**Given** valid artifact path
**When** A function like `parse_artifact <path>` is called
**Then** the frontmatter and a summary of the body is returned as json

> [!Note] Bodies are summarized by truncation
>unless a better strategy can be idendified.

> [!Question] In addition to frontmatter, what should be parsed from an artifact?
> Full/relative paths?
> Word counts?
> Formatted elements?

## Templates

- each artifact has a template, it is mostly used as a boilerplate file that is copied
and renamed with minimal changes. Information is manually
filled out in the artifact template.
- each index has a different template type. They are more complex and
"merged" with data from a JSON file. Sections are repeated. All information in the end result is generated and not edited manually.
- each index is made up of two parts, the index header and the body
which is a collection of sections that represent each file being indexed
- the header contains high level informaiton (file counts, date updated, ...)
- the index section contains information relavent to each file being indexed

> [!Question] What information about be useful to include in the header? Each artifact type?

## Index

A process that:

- "Scrapes" information from artifacts (markdown)
- Records the information in a structured form (json)
- Produces convenient, navigable index files (markdown)

### Process

> [!Question] How can indexes be built from a template or customized for each project?
> Maybe the parse part of indexing always pulls frontmatter and some kind
> of easy body summarization (truncate) and a template can just f-string style
> put data where available
> **Valid** artifacts, indexes, and templates would then need to be files
> that request and expose shared frontmatter keys
> **Valid** artifacts, indexes, and templates would then need to be files
> have can be parsed for templating

> [!Question] What is the process for indexing
> Maybe indexing should be done using an intermediate step: artifact files
> are parsed (when needed) and that data is recorded in a form that can
> be easily interpolated into a md file to present the data.
> Collecting all frontmatter data into one file and then using that
> as an index cache, using it to populate a template could be an effective strategy.
> It is easier to update only the require records when needed and the
> actual index file can be built from scratch anytime the index is updated.

### Hard Index Command

- indexes can be created "from scratch"

**Given** an activated environment
**Given** existing index files
**Given** existing artifact files
**When** `crisp index --hard` is executed
**Then** all index files are deleted
**Then** all artifacts are indexed and new index files are created
**Then** Crisp reports index and operation status

**Given** an inactive environment
**When** `crisp index --hard` is executed
**Then** Crisp reports there is no environment active

**Given** an activated environment
**Given** no existing index files
**Given** no existing artifact files
**When** `crisp index --hard` is executed
**Then** Crisp completes operation
**Then** Crisp reports index and operation status (should be 0)

**Given** an activated environment
**Given** no existing index files
**Given** existing artifact files
**When** `crisp index --hard` is executed
**Then** all artifacts are indexed and new index files are created
**Then** Crisp reports index and operation status (should be 0)

### Soft Index Command

Indexing can be a time consuming process for projects that have many artifacts.
Soft indexing updates indexes with only recently changed data, instead
indexing all artifacts.

- indexes are updated only when needed by looking at timestamps, to reduce
time to index and number of lines to scan
- indexes are updated only when needed, preserving previously indexed information
into new version of index file

> [!Question] About how long does it take to index a given set of files?

**Given** a project with existing index files
**Given** a project with existing index files
**When** I run `crisp index`
**When** I run `crisp index --soft`
**Then** entries in the index that point to unchanged artifacts persist in the
next version of the index file, and only entries for updated artifacts are changed

#### Identify Recently Modified Files

**Given** an activated environment
**When** a function like `get_pending <artifact_type>` is called
**Then** the function returns an array of filepaths where the modfied timestamp
of the artifact's file is after the timestamp of its relavent index file

### Rendering Indexes in Markdown

**Given** an activated environment
**Given** an `index_cache.json` exists
**Given** an `index_cache.json` is valid
**Given** the template requests elements that exist in the source
**Given** `<artifact_type>_index.md` exists or does not exists
**When** a function like `render_index <source_path> <template_path> <destination_path>`
is called
**Then** a markdown file is rendered, overwriting or creating at the destination
**Then** each item in the source uses the template to render a markdown section,
all sections are appended to the destination file

- see a short summary of all artifacts in index files
- see a link to the index so that I can review or navigate to them easily

> [!Question] What would be useful information for an overview of each artifact?

> [!Question] What information should be included for each artifact type?
