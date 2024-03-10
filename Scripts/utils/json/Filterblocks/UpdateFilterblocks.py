### TOWER SURVEY VARIABLES ################################################################

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

filterblock_name = 'Specific application filters'
new_condition = {
    "Name" : survey_application_name,
    "Token" : survey_application_token,
    "String" : "else if \"" + survey_application_token + "\" in [logstash_pipeline_token]"
}
new_filters = []
if survey_filter_1_value != "":
    survey_filter_1_object = {
        "Name" : survey_filter_1_name,
        "Type" : survey_filter_1_type,
        "Content" : survey_filter_1_value
    } 
    new_filters.append(survey_filter_1_object)
if survey_filter_2_value != "":
    survey_filter_2_object = {
        "Name" : survey_filter_2_name,
        "Type" : survey_filter_2_type,
        "Content" : survey_filter_2_value
    }
    new_filters.append(survey_filter_2_object)
if survey_filter_3_value != "":
    survey_filter_3_object = {
        "Name" : survey_filter_3_name,
        "Type" : survey_filter_3_type,
        "Content" : survey_filter_3_value
    }
    new_filters.append(survey_filter_3_object)
if survey_filter_4_value != "":
    survey_filter_4_object = {
        "Name" : survey_filter_4_name,
        "Type" : survey_filter_4_type,
        "Content" : survey_filter_4_value
    }
    new_filters.append(survey_filter_4_object) 
if survey_filter_5_value != "":
    survey_filter_5_object = {
        "Name" : survey_filter_5_name,
        "Type" : survey_filter_5_type,
        "Content" : survey_filter_5_value
    }
    new_filters.append(survey_filter_5_object)



### APPEND ADDITIONNAL FILTER(S) TO FILTERS OBJECT ######################################
    
additional_filter_object = {
    "Name" : "Date Filter",
    "Type" : "date",
    "Content" : "locale => \"en\"\nmatch => \"[\"app_timestamp\"], \"yyyy-MM-dd HH:mm:ss,SSS\"]\ntimezone => \"Europe/Paris\"\ntarget => \"timestamp\"\nadd_field => { \"hello\" => \"world\" }"
}
new_filters.append(additional_filter_object)



### MAIN FUNCTION ########################################################################

def main(json_filterblocks_file_path):

    filterblocks_obj = get_json_data(json_filterblocks_file_path)
    # print("Version = " + filterblocks_obj['GENERAL']['Version'])

    filterblock_name_found_in_file = False
    for filterblock in filterblocks_obj['FILTERBLOCKS']:

        if filterblock['Name'] == filterblock_name:

            filterblock_name_found_in_file = True
            token_found_in_file = False
            for condition in filterblock['Conditions']:

                if condition['Token'] == new_condition["Token"]:
                    token_found_in_file = True
                    condition['Name'] = new_condition["Name"]
                    condition['String'] = new_condition["String"]
                    condition['Filters'] = []

                    # Add new grok filters to reset Filters list
                    for index, value in enumerate(new_filters):
                        new_filter_object = {
                            "Name" : value["Name"], 
                            "Type" : value["Type"],
                            "Content" : value["Content"] 
                        }
                        condition['Filters'].append(new_filter_object)

                    # # Add timestamp filter
                    # date_filter = {
                    #     "Name": "Date filter",
                    #     "Type": "date",
                    #     "Content": "locale => \"en\"\nmatch => \"[\"app_timestamp\"], \"yyyy-MM-dd HH:mm:ss,SSS\"]\ntimezone => \"Europe/Paris\"\ntarget => \"timestamp\"\nadd_field => { \"hello\" => \"world\" }"
                    # }
                    # condition['Filters'].append(date_filter)       

            if token_found_in_file == False:
                # todo : add new Condition
                print("not implemented yet")
                sys.exit(1)

    if filterblock_name_found_in_file == False:
       # todo : add new Filterblock
        print("not implemented yet")
        sys.exit(1)

    
    # Show result
    print(json.dumps(filterblocks_obj))



### OTHER FUNCTIONS #####################################################################

def get_json_data(json_file_path):
    f = open(json_file_path)
    return(json.load(f))



### END OF SCRIPT #######################################################################

if __name__ == '__main__':
    main(sys.argv[1])

