public class  gDriveInfo {
    
    public String id;
    public String etag;
    public String selfLink;
    public String webContentLink;
    public String alternateLink;
    public String embedLink;
    public String iconLink;
    public String thumbnailLink;
    
    

    
    
    
    public static gDriveInfo parse(String json) {
        return (gDriveInfo) System.JSON.deserialize(json, gDriveInfo.class);
    }
}