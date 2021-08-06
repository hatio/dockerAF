
# Run pipelines

Scripts provided here are meant to be examples/templates for your analyses.
As such, we recommend copying the script to your project directory and work from there.

## Example project

Let's say we want to obtain SARS-CoV-2 consensus sequences for a new batch of viruses.
We can use the `afsov2-css` pipeline which first performs reference mapping to obtain the first round of consensus sequences. For ones with ambiguous bases, it performs genome-guided assembly to fill in those unknowns.

