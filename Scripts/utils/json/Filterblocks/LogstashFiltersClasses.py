class LogstashFilterBlock:
    
    def __init__(self, fbname, fbconditions = []):
        self.name = fbname
        self.conditions = fbconditions

    def add_condition(self, fbcondition):
        return True
    

class LogstashFilterblockCondition:

    def __init__(self, fbcname, fbcstring, fbcfilters = []):
        self.name = fbcname
        self.string = fbcstring
        self.filters = fbcfilters


class LogstashFilter:
    
    def __init__(self, filtername, filtertype, filtercontent):
        self.name = filtername
        self.type = filtertype
        self.content = filtercontent