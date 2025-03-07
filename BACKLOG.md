## Crisp CLI Backlog

This is a structured backlog for implementing the Crisp CLI.

### Artifact Creation

**Goal**
    Allow users to create artifacts of a specified type for project planning.

**User Story**

    As a user, I want to create artifacts of a specified type so I can fill them out with a text editor and plan my project.

**Acceptance Criteria**:

    **Given** an activated environment,  
    **When** I execute the command `crisp <item>`,  
    **Then** Crisp creates the item in the `.crisp/<item>` folder of the current environment.

### Indexing

**Goal**
    Provide a way to summarize and navigate artifacts through index files.

**User Story**:  
    As a user, I want to see a short summary of all artifacts in index files so that I can review or navigate to them easily.

**Acceptance Criteria**

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

### Optimized Indexing

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
