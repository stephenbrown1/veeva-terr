public with sharing class VS_AccountAlignmentCallout {
	@future (callout=true)
    public static void calloutAssignTerritories(String sessID, String acctIds) {
        /*
        HFK. 6/20/2012.  We are trying to automate the Zip to Terr alignment of Accounts.
        This can be done my doing the action associated with the Assign Territory custom Account button.
        So we need to create the URL which is used to call getVoDURL("assignterritory",params).

        getVoDURL is defined as :

        VOD_URL+"?VER="+VOD_VERSION+"&ses={!API.Session_ID}&url=" + encodeURIComponent("{!API.Partner_Server_URL_150}") + "&SSID=" + getCookie("sid") + "&oType=" + oType + paramString; 

        In this case, paramString is set to a comma delmited list of the Account IDs we are assigning territories for.

        We get the current values of VOD_URL and VOD_VERSION from the VSESSION scontrol, whose content looks like this:

        var VOD_SERVER_URL="https://vs6.vod309.com";
        var VOD_VERSION="15.0.5.1";
        var VOD_URL=VOD_SERVER_URL +"/" +VOD_VERSION;

        So we will query the SControl table to get the text of the VESSION SControl, and parse it.

        Note that we don't have access to session ID in a future method, so this is set by a trigger which passes it in.
        It also passes the comma delimited list of Accounts to be aligned.

        */

        // Get the text of VESSION
        
        String VOD_SERVER_URL = VOD_Common.VOD_SERVER_URL;
        String VOD_VERSION = VOD_Common.VOD_VERSION;
        
        System.debug ('hk: VSU = ' + VOD_SERVER_URL) ;
        System.debug ('hk: VV = ' + VOD_VERSION) ;

        // Get the base URL
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();

        // For some reason, we soemtimes get this with http rather than https.  Fix if necessary
        if (!baseURL.contains('https')) {
            baseURL = baseURL.replace('http','https') ;
        }

        // Now put it all together
        String urlx= VOD_SERVER_URL + '/' + VOD_VERSION +
        '?VER=' +
        VOD_VERSION +
        '&ses=' + sessID + '&url=' +
        EncodingUtil.urlEncode(baseURL + '/services/Soap/u/24.0/' + UserInfo.getOrganizationId(), 'UTF-8') +
        '&SSID=' + sessID +
        '&oType=assignterritory&accountIds=' + acctIds;
        system.debug (urlx) ;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(urlx);
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('hk:' + res.getBody());
 
    }

}