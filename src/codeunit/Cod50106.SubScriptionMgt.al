codeunit 50106 SubScriptionMgt
{
    var
        ClientIdTxt: Label '0420680b-c0c3-4b05-af75-ce09feb8b80a';
        ClientSecretTxt: Label '-ci8Q~pThamQCU.XDr5p59TQVGNT63yhjEj0Ncbb';
        AadTenantIdTxt: Label '3b5ff753-4aa1-41c3-8a58-e148e35fa1ab';
        AuthorityTxt: Label 'https://login.microsoftonline.com/{AadTenantId}/oauth2/v2.0/token';
        BCEnvironmentNameTxt: Label 'sandboxth';
        BCCompanyIdTxt: Label '02329a47-fac0-ef11-b8ec-6045bd1b7f3d';
        BCBaseUrlTxt: Label 'https://api.businesscentral.dynamics.com/v2.0/{BCEnvironmentName}/api/nwth/nwth/v2.0/companies({BCCompanyId})';
        AccessToken: Text;
        AccesTokenExpires: DateTime;
        AppId: Label 'bbc6d2fd-b9f8-498b-ad77-701802211267';

    trigger OnRun()
    var
        //Customers: Text;
        //Items: Text;
        subscriptionVar: Text;
    begin
        //Customers := CallBusinessCentralAPI(BCEnvironmentNameTxt, BCCompanyIdTxt, 'customers');
        //Items := CallBusinessCentralAPI(BCEnvironmentNameTxt, BCCompanyIdTxt, 'items');
        //Message(Customers);
        //Message(Items);
        subscriptionVar := CallBusinessCentralAPI(BCEnvironmentNameTxt, BCCompanyIdTxt, 'nwthsubscriptions');
        Message(subscriptionVar);
    end;

    procedure HttpRequestPOSTWithBasicAuth() Result: Text
    var
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        Base64Convert: Codeunit "Base64 Convert";
        Response: Text;
        JsonObject: JsonObject;
        JsonBuffer: Record "JSON Buffer" temporary;

        ContentHeaders: HttpHeaders;
        HttpContent: HttpContent;
        url: Text;
        BCEnvironmentName: Text;
        BCCompanyId: Text;
        Resource: Text;

        AzureADTenant: Codeunit "Azure AD Tenant";
    begin
        BCEnvironmentName := BCEnvironmentNameTxt;
        BCCompanyId := BCCompanyIdTxt;
        Resource := 'nwthsubscriptions';
        if (AccessToken = '') or (AccesTokenExpires = 0DT) or (AccesTokenExpires < CurrentDateTime) then
            GetAccessToken(AadTenantIdTxt);
        HttpClient.DefaultRequestHeaders.Add('Authorization', GetAuthenticationHeaderValue(AccessToken));
        HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');

        Url := GetBCAPIUrl(BCEnvironmentName, BCCompanyId, Resource);
        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method('POST');
        RequestMessage.GetHeaders(RequestHeaders);
        //RequestHeaders.Add('Authorization', 'Basic ' + Base64Convert.ToBase64(Username + ':' + Password));
        // AppId is now declared in the variable section
        HttpContent.WriteFrom('{"customertenantid": "' + AzureADTenant.GetAadTenantId() + '","appid": "' + AppId + '"}');
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(ContentHeaders);
        RequestMessage.Content(HttpContent);

        if HttpClient.Send(RequestMessage, ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(Response);
            if ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(Result);
            end else
                Message('Request failed!: %1', Response);
        end;
    end;

    procedure CallBusinessCentralAPI(BCEnvironmentName: Text; BCCompanyId: Text; Resource: Text) Result: Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Url: Text;
    begin
        if (AccessToken = '') or (AccesTokenExpires = 0DT) or (AccesTokenExpires > CurrentDateTime) then
            GetAccessToken(AadTenantIdTxt);
        Client.DefaultRequestHeaders.Add('Authorization', GetAuthenticationHeaderValue(AccessToken));
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');
        Url := GetBCAPIUrl(BCEnvironmentName, BCCompanyId, Resource);
        if not Client.Get(Url, Response) then
            if Response.IsBlockedByEnvironment then
                Error('Request was blocked by environment')
            else
                Error('Request to Business Central failed\%', GetLastErrorText());
        if not Response.IsSuccessStatusCode then
            Error('Request to Business Central failed\%1 %2', Response.HttpStatusCode, Response.ReasonPhrase);
        Response.Content.ReadAs(Result);
    end;

    local procedure GetAccessToken(AadTenantId: Text)
    var
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
    begin
        Scopes.Add('https://api.businesscentral.dynamics.com/.default');
        if not OAuth2.AcquireTokenWithClientCredentials(ClientIdTxt, ClientSecretTxt, GetAuthorityUrl(AadTenantId), '', Scopes, AccessToken) then
            Error('Failed to retrieve access token\', GetLastErrorText());
        AccesTokenExpires := CurrentDateTime + (3599 * 1000);
    end;

    local procedure GetAuthenticationHeaderValue(AccessToken: Text) Value: Text;
    begin
        Value := StrSubstNo('Bearer %1', AccessToken);
    end;

    local procedure GetAuthorityUrl(AadTenantId: Text) Url: Text
    begin
        Url := AuthorityTxt;
        Url := Url.Replace('{AadTenantId}', AadTenantId);
    end;

    local procedure GetBCAPIUrl(BCEnvironmentName: Text; BCCOmpanyId: Text; Resource: Text) Url: Text;
    begin
        Url := BCBaseUrlTxt;
        Url := Url.Replace('{BCEnvironmentName}', BCEnvironmentName)
                  .Replace('{BCCompanyId}', BCCOmpanyId);
        Url := StrSubstNo('%1/%2', Url, Resource);
    end;
}