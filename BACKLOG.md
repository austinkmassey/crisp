This is a structured backlog for implementing the Crisp CLI.

## Environment Management

Users can activate and deativate project specific crisp environments in their shell.

### Activate Environment

**Acceptance Criteria**

    **Given** a valid crisp installation
    **When** `source .crisp/scripts/activate.sh` is executed
    **Then** Crisp commands and environmental variables are sourced into the shell

### Deactivate Environment

**Acceptance Criteria**

    **Given** an activated environment
    **When** `source .crisp/scripts/deactivate.sh` is executed
    **Then** Crisp commands and environmental variables are removed from the shell

## Artifacts Management

### Create Artifacts

### Acceptance Criteria

    **Given** an activated environment
    **When** The command `crisp <item>` is executed
    **Then** Crisp creates the item in the output folder of the current environment.

### Customize Artifacts

### Acceptance Criteria

    **Given** an activated environment
    **When** The command `crisp <item>` is executed
    **Then** A template in .crisp/templates, of the correct type, is used as the base of the new item.

## Index

Provide a way to summarize and navigate artifacts through index files.
    
 - see a short summary of all artifacts in index files
 - see a link to the index so that I can review or navigate to them easily
 - indexes can be created "from scratch"
 - indexes are updated only when needed by looking at timestamps, to reduce time to index and number of lines to scan
 - indexes are updated only when needed, preserving previously indexed information into new version of index file

### Acceptance Criteria

    **Given** a project with artifacts,  
    **When** I run `crisp index`,  
    **Then** all index files are updated to reflect the current artifacts.
    
    **Given** a project with existing index files,  
    **When** I run `crisp index`,  
    **Then** only artifacts with modified timestamps after the modified timestamp of their index file are parsed and updated.
    
    **Given** a project with existing index files,  
    **When** I run `crisp index`,  
    **Then** entries in the index that point to unchanged artifacts persist in the next version of the index file, and only entries for updated artifacts are changed.

**User Story**
    As a user, I want to completely reset all index files with `crisp index --hard` so that I can confidently see the current state of all artifacts.

**Acceptance Criteria**

    **Given** a project with existing indexes and artifacts,  
    **When** I execute `crisp index --hard`,  
    **Then** all index files are deleted and recreated from scratch.

**Goal**
    Streamline artifact summarization and ensure efficient indexing functionality.

**User Story**
    As a developer, I want to summarize artifacts through one interface so that the summarizing functionality is easy to integrate and customize.

**Acceptance Criteria**

    **Given** an artifact path,  
    **When** I call a function like `summarize_artifact`,  
    **Then** a type-specific summary of the artifact is returned.

**User Story**
    As a user, I want indexing to only require parsing and scanning files that have been updated so that the indexing process is fast.

**Acceptance Criteria**

    **Given** an artifact directory and an index file,  
    **When** I call a function like `get_modified_artifacts`,  
    **Then** a list of files that are newer or modified after the index file is returned.
   
    **Given** an index file,  
    **When** I call a function like `parse_index`,  
    **Then** an associative array, keyed by paths, is returned.
