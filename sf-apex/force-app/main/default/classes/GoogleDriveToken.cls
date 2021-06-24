public Class GoogleDriveToken{
    
    public String get_access_token(){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setMethod('POST');
        
        req.setHeader('ContentType','application/x-www-form-urlencoded');
        
        String header = '{"alg":"RS256","typ":"JWT"}';
        String header_encoded = EncodingUtil.base64Encode(blob.valueof(header));
        
        String claim_set = '{"iss":"on-borading@on-boardin.iam.gserviceaccount.com"';
        claim_set += ',"scope":"https://www.googleapis.com/auth/drive.file"';
        claim_set += ',"aud":"https://accounts.google.com/o/oauth2/token"';
        claim_set += ',"exp":"' + datetime.now().addHours(1).getTime()/1000;
        claim_set += '","iat":"' + datetime.now().getTime()/1000 + '"}';
        
        String claim_set_encoded = EncodingUtil.base64Encode(blob.valueof(claim_set));
        
        String signature_encoded = header_encoded + '.' + claim_set_encoded;
        
        String key = 'MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCjt29xVCIGGmjTKsnW7Y5H9p1h0e6pIYFyNURgpMcJj69qdWMbffKdNQV3m6zb1MgLztzS7+4mwkm3q8O+KFPpbra8botwvxRcNWITcBV4XCSgglYu6JBtvyy9Gt2ub2jv3Qjh/48VHfupOQZ0dE3CsNgcztJxMmF5NAaDZ8NB2AfhMHDsI4HSNEEimCmJIbX4IwQz9P5Ky9Dii1AHRsQW4AYvBdanhwlxn0tP7Qk+ao3YGT8lPLAJnPkmh4rIER5Yv9FhRPsUUmDeb0tdp/woAiRTNxYJklYY5QND15G/uafWsWgAyIavMXpYVjGfMJdJKQN+uNrjNwP5nI2MEGUpAgMBAAECggEANq3e5jJr1K8AYLrTQ9n+odFfuhqUA+ABbGQXDNIr+ekH9N309msn21Kom0yevKNCFxOFlFv3JfHRDiurijjM4dOM671eDA99nNhlg8l1GkhoIUW2xB7/ke/+YMB21ro2CZrAyz6ACtUDRv8ZRU7M4+ANpf17srvZa1IxdLT0tWoJOmMNC5xKjJc5xa610yheVk6YHf8SpNn7fFyLEmYg5qzj/wBwG1NyKUXRoF0lCYlcmJXsQm3j+mtNsVYE/v3Ms+ZsZvfLUPSU6931Fl26zaibFgdvNIKd0sHsoHgM53ZN5kATyh6As+zfMoaDPPnLRqtChV3X6oruv8iELZAygwKBgQDW3Fiddg2lSdlQRsShvNjUEnKgW4fDx3ggPHdiMICoEx7wsaVeZfugkq3VxLekvoTkQ/Y7dnQ8wLWjFSGPGMP7wqCW0QWmIoeAD4/FM/++2PikmzVQw3Ttrf2AY6w6M6vqRjBHykkiUXb7f/B+JN3JCYNhmosqBevbz+FRCClACwKBgQDDEDI+7L1UVprIeYfOlN/VDajgX6k/uuoxAR3KDQ0NOlKa3Ltuarrq4IW4WN4Le2I/qGA4L6rNj07gWwaZ8DbpPwdoNPvoss0MlGJ5jpA+cEzx3dwPpaicf++hHbEwOGjtWiqu0kS3lNljWZ00nAknv/ua1N7XZyPhKADQb1ZsGwKBgQCAFGvyuXva6xHTK8xtSaDLko+oDcf5qf9u3/yemKEpD/TisFMO2aZNCwL7Kj/6weOAGw8+VRdnW80rAR63KaEyg8us+77tUSoK6bvfZ2btwnM91JPMqCccxBoYndH+A+1YQyzmrqw3++38cEDRQXLAM56Q4UpR66O0rc/3uPC2DwKBgQCllc0hb3P08SOpxMjNS8GKqXLPLUWOTQxalxkDmPqYXQccYP5W6BFOK1Q4PnAXjSDE6xjq+UPkBaAugfbjnG/wpkmSY0/opEe+QwQpLiUya8BVnUEeo0CzwULZIUx1o50mx2DuUJ52vMuhM8RokYCQFr/uGoAkmHBzxLKUPb8+OwKBgGhw7axn369QEx36QA2ci9D0A4OESYggr07+AMH1QHXaTCCqmc5g20EE/hDAmAoyBAyxilQVl3dU4OxRsiz8lgw0zBn7xr3BCnohDbxfj1qkvTm8eLJnCphnndX48CT9JkEkJXd8BICsjcxnoifOhe7pcLbaZStp91+jFkubrVac';
        
        blob private_key = EncodingUtil.base64Decode(key);
        signature_encoded = signature_encoded.replaceAll('=','');
        String signature_encoded_url = EncodingUtil.urlEncode(signature_encoded,'UTF-8');
        blob signature_blob =   blob.valueof(signature_encoded_url);
        
        String signature_blob_string = EncodingUtil.base64Encode(Crypto.sign('RSA-SHA256', signature_blob, private_key));
        
        String JWT = signature_encoded + '.' + signature_blob_string;
        
        JWT = JWT.replaceAll('=','');
        
        String grant_string= 'urn:ietf:params:oauth:grant-type:jwt-bearer';
        req.setBody('grant_type=' + EncodingUtil.urlEncode(grant_string, 'UTF-8') + '&assertion=' + EncodingUtil.urlEncode(JWT, 'UTF-8'));
        res = h.send(req);
        String response_debug = res.getBody() +' '+ res.getStatusCode();
        System.debug('Response =' + response_debug );
        if(res.getStatusCode() == 200) {
           JSONParser parser = JSON.createParser(res.getBody());
           /*
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    // Move to the value.
                    parser.nextToken();
                    // Return the access_token
                    System.debug('>>>>>>'+parser.getText());
                    return parser.getText();
                }
            }
*/
        }
        return 'error';
        
        
        
    }
}