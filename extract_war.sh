#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Extract the Well-Architected findings to json and csv. Requires jq to be installed."
   echo
   echo "Syntax: extract_war [-i <string>] [-a <string>]"
   echo "options:"
   echo "-i    The worload id"
   echo "-a    The lens alias"
   echo
}
############################################################
############################################################
# Main program                                             #
############################################################
############################################################
# Set variables
id="workloadid"
alias="lensalias"

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts "i:a:h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      i) # display Help
         id=${OPTARG};;
      a) # Enter a name
         alias=${OPTARG};;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

aws wellarchitected list-lens-review-improvements --workload-id $id --lens-alias $alias --max-results 100 | jq '.ImprovementSummaries' > findings.json
jq -r 'map({QuestionId,PillarId,QuestionTitle,Risk,ImprovementPlanUrl}) | (first | keys_unsorted) as $keys | map([to_entries[] | .value]) as $rows | $keys,$rows[] | @csv' findings.json > findings.csv