public with sharing class largeDV implements Queueable {
    //Query controllers
    private static final Integer chunkSize = 20;
    private Id offsetId  = null;
    //Query objects
    private List<Account> objectToProcess;
   
    @testVisible
    private static Integer chunksExecuted = 0;

    public largeDV(Id offsetId) {
         this.objectToProcess = getRecordsToProcess(this.offsetId); //get query records 
    }
    //Note :  Process the records
    public void execute(System.QueueablContext queueableContext){
        largeDV.chunksExecuted += 1; //verify method exu counter




        
        id lastRecordId  = objectToProcess[objectToProcess.size()].id; //get last record id
        //if the records procesed recall constrc
        if (getRecordsToProcess(lastRecordId).size() > 0 && safeToReenqueue()) {
            largeDV newQueueable = new largeDV(lastRecordId);
            System.enqueueJob(newQueueable);
        }
    } 
   
    //helper method
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
    private Boolean safeToReenqueue() {
        return Limits.getLimitQueueableJobs() > Limits.getQueueableJobs(); //compare if the stack has space to new Que
    }
}
