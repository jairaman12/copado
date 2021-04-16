/**************************************************************************************************
Apex Class Name  : NetworkJsonSupportCls
Version          : 1.0  
Functionality    : Supporting class to hold the JSON deserealized data 
			       for Add and Change mode
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru          06/27/2018              Sprint 13
***************************************************************************************************/
public class NetworkJsonSupportCls 
{
    public List<NetworkGroups> networkGroups;

	public class NetworkGroups {
		public String effectiveDate;
		public String comments;
		public List<SelectedNetworks> selectedNetworks;
	}

	public class Designationcode {
		public String code;
		public String effectivedate;
		public String enddate;
	}

	public class SelectedNetworks {
		public String networkName;
		public String role;
		public String panel;
		public List<Designationcode> designationcode;
		public List<Designationcode> compgridcode;
	}
    
    /*************************************************************
     * @input: JSON string from manualCaseCreationController class
     * @output: Deserialized JSON output in array form
     **************************************************************/
    public static NetworkJsonSupportCls parse(String json) {
        System.debug('json===>>>'+json);
		return (NetworkJsonSupportCls) System.JSON.deserialize(json, NetworkJsonSupportCls.class);
	}
}