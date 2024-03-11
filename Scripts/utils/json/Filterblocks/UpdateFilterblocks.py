### TOWER SURVEY VARIABLES ################################################################
survey_filterblock_name = 'Specific application filters'
survey_application_name = "MyApp 2.0"
survey_application_token = "1d564fz6e4f6ze4f6zed4ez"
survey_filter_1_name = "Example filter 1 for My App"
survey_filter_1_type = "Grok"
survey_filter_1_value = r'match => { "message" => "?<app_timestamp>%{GREEDYDATA} %{GREEDYDATA}) :: %{LOGLEVEL} :: %{IPV4} - - \[%{GREEDYDATA}\ %{TIME}\]  %{WORD:http_method}%{GREEDYDATA:url_path} HTTP/%{NUMBER:http_version}  %{NUMBER:http_status_code} -" }'
survey_filter_2_name = "Example filter 2 for My App"
survey_filter_2_type = "Grok"
survey_filter_2_value = r"""
match => { "message" => [
	# Most specific
	"%{DATE:my_log_date} %{TIME:my_log_TIME} :: %{LOGLEVEL} :: %{IPV4} - - \[%{GREEDYDATA}\ %{TIME}\] %{WORD:http_method} %{GREEDYDATA:url_path} HTTP/%{NUMBER:http_version} %{NUMBER:http_status_code} -",
	# Less specific
	"%{TIMESTAMP_ISO8601:temp_date} -- {GREEDYDATA:log_message}",
	# Raw:
	"%{GREEDYDATA:log_message}" ]
"""
survey_filter_3_name = ""
survey_filter_3_type = ""
survey_filter_3_value = ""
survey_filter_4_name = ""
survey_filter_4_type = ""
survey_filter_4_value = ""
survey_filter_5_name = ""
survey_filter_5_type = ""
survey_filter_5_value = ""


### IMPORTS ###############################################################################
import json
import sys


### SET SCRIPT VARIABLES ##################################################################
condition_object = {
    "Name" : survey_application_name,
    "Token" : survey_application_token,
    "String" : "else if \"" + survey_application_token + "\" in [logstash_pipeline_token]",
    "Filters" : [] 
}
if survey_filter_1_value != "":
    survey_filter_1_object = {
        "Name" : survey_filter_1_name,
        "Type" : survey_filter_1_type,
        "Content" : survey_filter_1_value
    } 
    condition_object['Filters'].append(survey_filter_1_object)
if survey_filter_2_value != "":
    survey_filter_2_object = {
        "Name" : survey_filter_2_name,
        "Type" : survey_filter_2_type,
        "Content" : survey_filter_2_value
    }
    condition_object['Filters'].append(survey_filter_2_object)
if survey_filter_3_value != "":
    survey_filter_3_object = {
        "Name" : survey_filter_3_name,
        "Type" : survey_filter_3_type,
        "Content" : survey_filter_3_value
    }
    condition_object['Filters'].append(survey_filter_3_object)
if survey_filter_4_value != "":
    survey_filter_4_object = {
        "Name" : survey_filter_4_name,
        "Type" : survey_filter_4_type,
        "Content" : survey_filter_4_value
    }
    condition_object['Filters'].append(survey_filter_4_object) 
if survey_filter_5_value != "":
    survey_filter_5_object = {
        "Name" : survey_filter_5_name,
        "Type" : survey_filter_5_type,
        "Content" : survey_filter_5_value
    }
    condition_object['Filters'].append(survey_filter_5_object)


### APPEND ADDITIONNAL FILTER(S) TO FILTERS OBJECT ######################################
additional_filter_object = {
    "Name" : "Date Filter",
    "Type" : "date",
    "Content" : "locale => \"en\"\nmatch => \"[\"app_timestamp\"], \"yyyy-MM-dd HH:mm:ss,SSS\"]\ntimezone => \"Europe/Paris\"\ntarget => \"timestamp\"\nadd_field => { \"hello\" => \"world\" }"
}
condition_object['Filters'].append(additional_filter_object)


### MAIN FUNCTION ########################################################################
def main(json_filterblocks_file_path):

    filterblocks_obj = get_json_data(json_filterblocks_file_path)

    survey_filterblock_name_found_in_file = False
    for filterblock in filterblocks_obj['FILTERBLOCKS']:

        ## UPDATE existing block ####################  
        if filterblock['Name'] == survey_filterblock_name:

            survey_filterblock_name_found_in_file = True
            token_found_in_file = False
            for condition in filterblock['Conditions']:

                # UPDATE existing condition 
                if condition['Token'] == condition_object["Token"]:
                    token_found_in_file = True
                    condition['Name'] = condition_object["Name"]
                    condition['String'] = condition_object["String"]
                    condition['Filters'] = condition_object["Filters"]

            # or, CREATE new condition 
            if token_found_in_file == False:
                filterblock['Conditions'].append(condition_object)

    ## or, CREATE new block and condition ################
    if survey_filterblock_name_found_in_file == False:

        # Add condition object to new block object
        new_filterblock_object = {
            "Name" : survey_filterblock_name,
            "Conditions" : condition_object
        }
        filterblocks_obj['FILTERBLOCKS'].append(new_filterblock_object)

    
    # Show result
    print(json.dumps(filterblocks_obj))


### OTHER FUNCTIONS #####################################################################
def get_json_data(json_file_path):
    f = open(json_file_path)
    return(json.load(f))


### END OF SCRIPT #######################################################################
if __name__ == '__main__':
    main(sys.argv[1])

