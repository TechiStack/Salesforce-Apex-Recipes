public with sharing class largeDV implements Queueable {
    //Query controllers
    private static final Integer chunkSize = 500000;
    private Id offsetId  = null;
    //Query objects
    private List<Account> objectToProcess;

    public largeDV(Id offsetId) {
        if(offsetId  != null){
            this.offsetId = offsetId;
        }
        this.objectToProcess = getRecordsToProcess(this.offsetId);
    
       
    }
    //Note :  Process the records
    public void execute(System.QueueablContext queueableContext){






        id lastRecordId  = objectToProcess[objectToProcess.size()].id;
        //if the records procesed recall constrc
        largeDV newQuaueable = new largeDV(this.offsetId);
        system.enqueue(newQuaueable);
    } 
   
    private List<Account> getRecordsToProcess(id offsetId){
        String stringQuery = '';
        stringQuery =+'SELECT id,Name';
        stringQuery =+'FROM Account';
        this.offset = offset;
        if(offsetId  != null){
            stringQuery =+'WHERE Id > :offsetId';
        }
        stringQuery =+'order by id';
        stringQuery =+'LIMIT :this.chunkSize';
        return DATABASE.query(stringQuery);
    }
}
