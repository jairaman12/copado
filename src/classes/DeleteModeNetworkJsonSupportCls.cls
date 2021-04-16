/**************************************************************************************************
Apex Class Name  : DeleteModeNetworkJsonSupportCls
Version          : 1.0  
Functionality    : Supporting class to hold the JSON deserealized data 
			       for delete mode
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru          06/27/2018              Sprint 13
***************************************************************************************************/
public class DeleteModeNetworkJsonSupportCls 
{

    public List<NetworkGroups> networkGroups;

	public class NetworkGroups {
		public String effectiveDate;
		public String nwReason;
		public String comments;
		public List<String> selectedNetworks;
	}

	/*************************************************************
     * @input: JSON string from manualCaseCreationController class
     * @output: Deserialized JSON output in array form
     **************************************************************/
	public static DeleteModeNetworkJsonSupportCls parse(String json) 
    {
		return (DeleteModeNetworkJsonSupportCls) System.JSON.deserialize(json, DeleteModeNetworkJsonSupportCls.class);
	}
}