// ********RoostGPT********
/*
Test generated by RoostGPT for test karteKnoteTest using AI Type Open AI and AI Model gpt-4-1106-preview

Test generated for /recipients/branches_get for http method type GET in rest-assured framework

RoostTestHash=9e29236edf


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

public class recipientsBranchesGetTest {

    List<Map<String, String>> envList = new ArrayList<>();


    @BeforeEach
    public void setUp() {
      TestdataLoader dataloader = new TestdataLoader();
      String[] envVarsList = {""};
      envList = dataloader.load("src/test/java/com/learnk8s/RoostTest/recipients_branchesGetTest.csv", envVarsList);
    }

  
    @Test  
    public void recipientsBranchesGet_Test() throws JSONException {
        this.setUp();
        Integer testNumber = 1;
        for (Map<String, String> testData : envList) {
          RestAssured.baseURI = (testData.get("BASE_URL") != null && !testData.get("BASE_URL").isEmpty()) ? testData.get("BASE_URL"): "https://virtserver.swaggerhub.com/credentialregister/wallet/1.0.0";  
          JSONObject requestBodyObject = new JSONObject();
          if(testData.get("RequestBody") != null){
              requestBodyObject = new JSONObject(testData.get("RequestBody"));
          }
                Response responseObj = given()
				.queryParam("coc-number", testData.get("coc-number") != null ? testData.get("coc-number") : "")
				.queryParam("coc-branch-number", testData.get("coc-branch-number") != null ? testData.get("coc-branch-number") : "")
				.queryParam("trade-name", testData.get("trade-name") != null ? testData.get("trade-name") : "")
				.queryParam("size", testData.get("size") != null ? testData.get("size") : "")
				.queryParam("offset", testData.get("offset") != null ? testData.get("offset") : "")
				.header("Token", testData.get("Token"))
                .when()
                .get("/recipients/branches")  
                .then() 
                .extract().response(); 
              JsonPath response;
              String contentType = responseObj.getContentType();

              System.out.printf("Test Case %d: recipientsBranchesGet_Test \n", testNumber++);
              System.out.println("Request: GET /recipients/branches");
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
      
              if (response.get("total") != null) {
                  
                MatcherAssert.assertThat(response.get("total"), instanceOf(Integer.class));
              }
      
              if (response.get("branches") != null) {
                        
                  for (int i = 0; i < response.getList("branches").size(); i++) {      
              if (response.get("branches["+ i +"].id") != null) {
                  
                MatcherAssert.assertThat(response.get("branches["+ i +"].id"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].email") != null) {
                    
                MatcherAssert.assertThat(response.getString("branches["+ i +"].email"), matchesPattern("^(([^<>()[\\]\\.,;:\\s@\\"]+(\\.[^<>()[\\]\\.,;:\\s@\\"]+)*)|(\\".+\\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$")); 
  
                MatcherAssert.assertThat(response.get("branches["+ i +"].email"), instanceOf(String.class));MatcherAssert.assertThat(
                    response.getString("branches["+ i +"].email"),
                  Matchers.matchesPattern("^[^\s@]+@[^\s@]+\.[^\s@]+$")
                ); 

              }
      
              if (response.get("branches["+ i +"].phone") != null) {
                  
                MatcherAssert.assertThat(response.get("branches["+ i +"].phone"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].cocNumber") != null) {
                    
                MatcherAssert.assertThat(response.getString("branches["+ i +"].cocNumber"), matchesPattern("^\\d{8}$")); 
  
                MatcherAssert.assertThat(response.get("branches["+ i +"].cocNumber"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].cocBranchNumber") != null) {
                    
                MatcherAssert.assertThat(response.getString("branches["+ i +"].cocBranchNumber"), matchesPattern("^\\d{12}$")); 
  
                MatcherAssert.assertThat(response.get("branches["+ i +"].cocBranchNumber"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].tradeName") != null) {
                  
                MatcherAssert.assertThat(response.get("branches["+ i +"].tradeName"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].tradeNames") != null) {
                      
                for (int i1 = 0; i1 < response.getList("branches["+ i +"].tradeNames").size(); i1++) {      
                  }    
                MatcherAssert.assertThat(response.getList("branches["+ i +"].tradeNames"), instanceOf(List.class));

              }
      
              if (response.get("branches["+ i +"].eoriNumber") != null) {
                    
                MatcherAssert.assertThat(response.getString("branches["+ i +"].eoriNumber"), matchesPattern("^NL\\d{9}$")); 
  
                MatcherAssert.assertThat(response.get("branches["+ i +"].eoriNumber"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].deregistrationDate") != null) {
                  
                MatcherAssert.assertThat(response.get("branches["+ i +"].deregistrationDate"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].createdAt") != null) {
                  
                MatcherAssert.assertThat(response.get("branches["+ i +"].createdAt"), instanceOf(String.class));
              }
      
              if (response.get("branches["+ i +"].updatedAt") != null) {
                  
                MatcherAssert.assertThat(response.get("branches["+ i +"].updatedAt"), instanceOf(String.class));
              }
        
                    }    
                MatcherAssert.assertThat(response.getList("branches"), instanceOf(List.class));

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
