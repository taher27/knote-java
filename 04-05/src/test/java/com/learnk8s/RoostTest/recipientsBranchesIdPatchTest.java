// ********RoostGPT********
/*
Test generated by RoostGPT for test karteKnoteTest using AI Type Open AI and AI Model gpt-4-1106-preview

Test generated for /recipients/branches/{id}_patch for http method type PATCH in rest-assured framework

RoostTestHash=e4739a575e


*/

// ********RoostGPT********
package com.learnk8s.RoostTest;
import io.restassured.RestAssured;
import io.restassured.path.json.JsonPath;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static io.restassured.RestAssured.given;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import org.hamcrest.MatcherAssert;
import static org.hamcrest.Matchers.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;
import org.json.XML;
import org.json.JSONException;
import org.json.JSONArray;
import java.util.Arrays;

public class recipientsBranchesIdPatchTest {

    List<Map<String, String>> envList = new ArrayList<>();


    @BeforeEach
    public void setUp() {
      TestdataLoader dataloader = new TestdataLoader();
      String[] envVarsList = {"id"};
      envList = dataloader.load("src/test/java/com/learnk8s/RoostTest/recipients_branches_idPatchTest.csv", envVarsList);
    }

  
    @Test  
    public void recipientsBranchesIdPatch_Test() throws JSONException {
        this.setUp();
        Integer testNumber = 1;
        for (Map<String, String> testData : envList) {
          RestAssured.baseURI = (testData.get("BASE_URL") != null && !testData.get("BASE_URL").isEmpty()) ? testData.get("BASE_URL"): "https://virtserver.swaggerhub.com/credentialregister/wallet/1.0.0";  
          JSONObject requestBodyObject = new JSONObject();
          if(testData.get("RequestBody") != null){
              requestBodyObject = new JSONObject(testData.get("RequestBody"));
          }
                Response responseObj = given()
				.pathParam("id", testData.get("id") != null ? testData.get("id") : "")
				.contentType(ContentType.JSON)
				.body(requestBodyObject.toString())
				.header("Token", testData.get("Token"))
                .when()
                .patch("/recipients/branches/{id}")  
                .then() 
                .extract().response(); 
              JsonPath response;
              String contentType = responseObj.getContentType();

              System.out.printf("Test Case %d: recipientsBranchesIdPatch_Test \n", testNumber++);
              System.out.println("Request: PATCH /recipients/branches/{id}");
              System.out.println("Status Code: " + responseObj.statusCode());
              if (testData.get("statusCode") != null) {
                String statusCodeFromCSV = testData.get("statusCode");
                if (statusCodeFromCSV.contains("X")) {
                  MatcherAssert.assertThat(
                      "Expected a status code of category " + statusCodeFromCSV + ", but got "
                          + Integer.toString(responseObj.statusCode()) + " instead",
                      Integer.toString(responseObj.statusCode()).charAt(0), equalTo(statusCodeFromCSV.charAt(0)));
                } else {
                  MatcherAssert.assertThat(
                      Integer.toString(responseObj.statusCode()), equalTo(statusCodeFromCSV));
                }
              } 
              				else {  
      List<Integer> expectedStatusCodes = Arrays.asList(200,400,401);
				MatcherAssert.assertThat(responseObj.statusCode(), is(in(expectedStatusCodes)));
          }
				String stringifiedStatusCode = Integer.toString(responseObj.statusCode());
        switch(responseObj.statusCode()){
        
          case 200:
            stringifiedStatusCode = "200";
            MatcherAssert.assertThat(contentType, equalTo("application/json"));
            break;
         
          case 400:
            stringifiedStatusCode = "400";
            MatcherAssert.assertThat(contentType, equalTo("application/json"));
            break;
         
          case 401:
            stringifiedStatusCode = "401";
            MatcherAssert.assertThat(contentType, equalTo("application/json"));
            break;
         
    }

      switch(Integer.toString(responseObj.statusCode()).charAt(0)){
      
    }

      
              if (contentType.contains("application/xml") || contentType.contains("text/xml")) {
                String xmlResponse = responseObj.asString();
                JSONObject jsonResponse = XML.toJSONObject(xmlResponse);
                JSONObject jsonData = jsonResponse.getJSONObject("xml");
                String jsonString = jsonData.toString();
                response = new JsonPath(jsonString);
        
              } else if(contentType.contains("application/json")){  
                response = responseObj.jsonPath(); 
              } else {
                System.out.println("Response content type found: "+contentType+", but RoostGPT currently only supports the following response content types: application/json,text/xml,application/xml");
                continue;
              }
         
                if(stringifiedStatusCode.equals("200")){					System.out.println("Description: successful operation");
      
              if (response.get("id") != null) {
                  
                MatcherAssert.assertThat(response.get("id"), instanceOf(String.class));
              }
      
              if (response.get("email") != null) {
                    
                MatcherAssert.assertThat(response.getString("email"), matchesPattern("^(([^<>()[\\]\\.,;:\\s@\\"]+(\\.[^<>()[\\]\\.,;:\\s@\\"]+)*)|(\\".+\\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$")); 
  
                MatcherAssert.assertThat(response.get("email"), instanceOf(String.class));MatcherAssert.assertThat(
                    response.getString("email"),
                  Matchers.matchesPattern("^[^\s@]+@[^\s@]+\.[^\s@]+$")
                ); 

              }
      
              if (response.get("phone") != null) {
                  
                MatcherAssert.assertThat(response.get("phone"), instanceOf(String.class));
              }
      
              if (response.get("cocNumber") != null) {
                    
                MatcherAssert.assertThat(response.getString("cocNumber"), matchesPattern("^\\d{8}$")); 
  
                MatcherAssert.assertThat(response.get("cocNumber"), instanceOf(String.class));
              }
      
              if (response.get("cocBranchNumber") != null) {
                    
                MatcherAssert.assertThat(response.getString("cocBranchNumber"), matchesPattern("^\\d{12}$")); 
  
                MatcherAssert.assertThat(response.get("cocBranchNumber"), instanceOf(String.class));
              }
      
              if (response.get("tradeName") != null) {
                  
                MatcherAssert.assertThat(response.get("tradeName"), instanceOf(String.class));
              }
      
              if (response.get("tradeNames") != null) {
                      
                for (int i = 0; i < response.getList("tradeNames").size(); i++) {      
                  }    
                MatcherAssert.assertThat(response.getList("tradeNames"), instanceOf(List.class));

              }
      
              if (response.get("eoriNumber") != null) {
                    
                MatcherAssert.assertThat(response.getString("eoriNumber"), matchesPattern("^NL\\d{9}$")); 
  
                MatcherAssert.assertThat(response.get("eoriNumber"), instanceOf(String.class));
              }
      
              if (response.get("deregistrationDate") != null) {
                  
                MatcherAssert.assertThat(response.get("deregistrationDate"), instanceOf(String.class));
              }
      
              if (response.get("createdAt") != null) {
                  
                MatcherAssert.assertThat(response.get("createdAt"), instanceOf(String.class));
              }
      
              if (response.get("updatedAt") != null) {
                  
                MatcherAssert.assertThat(response.get("updatedAt"), instanceOf(String.class));
              }
				}
if(stringifiedStatusCode.equals("400")){					System.out.println("Description: Bad Request");
      
              if (response.get("error") != null) {
                  
                MatcherAssert.assertThat(response.get("error"), instanceOf(String.class));
              }
      
              if (response.get("description") != null) {
                  
                MatcherAssert.assertThat(response.get("description"), instanceOf(String.class));
              }
      
              if (response.get("error") != null) {
                    
                MatcherAssert.assertThat(response.getString("error"), matchesPattern("^validation/.*$")); 
  
                MatcherAssert.assertThat(response.get("error"), instanceOf(String.class));
              }
      
              if (response.get("description") != null) {
                  
                MatcherAssert.assertThat(response.get("description"), instanceOf(String.class));
              }
      
              if (response.get("field") != null) {
                  
                MatcherAssert.assertThat(response.get("field"), instanceOf(String.class));
              }
      
              if (response.get("schema_field") != null) {
                  
                MatcherAssert.assertThat(response.get("schema_field"), instanceOf(String.class));
              }
				}
if(stringifiedStatusCode.equals("401")){					System.out.println("Description: Authentication Required");
      
              if (response.get("error") != null) {
                  
                MatcherAssert.assertThat(response.get("error"), instanceOf(String.class));
              }
      
              if (response.get("description") != null) {
                  
                MatcherAssert.assertThat(response.get("description"), instanceOf(String.class));
              }
      
              if (response.get("error") != null) {
                    
                MatcherAssert.assertThat(response.getString("error"), matchesPattern("^validation/.*$")); 
  
                MatcherAssert.assertThat(response.get("error"), instanceOf(String.class));
              }
      
              if (response.get("description") != null) {
                  
                MatcherAssert.assertThat(response.get("description"), instanceOf(String.class));
              }
      
              if (response.get("field") != null) {
                  
                MatcherAssert.assertThat(response.get("field"), instanceOf(String.class));
              }
      
              if (response.get("schema_field") != null) {
                  
                MatcherAssert.assertThat(response.get("schema_field"), instanceOf(String.class));
              }
				}


            }  
    }
}
