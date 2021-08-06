
# Setup pipelines

Each analysis pipeline may involve more than one Docker container. Scripts listed here will pull the relevant containers from DockerHub, tagging them appropriately, so that the pipelines can be run with the example scripts provided in `03-runPipeline`.

To setup a pipeline, navigate to the root directory of this repository `dockerAF` and type the following into your Terminal.

    sh <pipeline_setup_script>
    
For instance, to setup the `afscov2-css` pipeline on your machine, type `sh afscov2-css.sh`.
You only need to set the pipelines up once. They can be used in multiple projects.
Rerunning these scripts will update the containers to the latest available version.
