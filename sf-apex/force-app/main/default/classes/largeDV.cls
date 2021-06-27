public with sharing class largeDV implements Queueable {
    //Query controllers
    private static final Integer chunkSize = 50000;
    private Id offsetId  = null;
    //Query objects
    private List<Account> objectToProcess;
   
    @testVisible
    private static Integer chunksExecuted = 0;

    public largeDV(Id offsetId) {
         this.objectToProcess = getRecordsToProcess(this.offsetId); //get query records 
         system.debug(chunksExecuted);
    }



    //Note :  Process the records
    public void execute(System.QueueableContext queueableContext){
        largeDV.chunksExecuted += 1; //verify method exu counter
      

        for(Account ac : this.objectToProcess){
            system.debug(ac.id);
        }



        Id lastRecordId = objectToProcess[objectToProcess.size() - 1].id;
        //if the records procesed recall constrc
        if (getRecordsToProcess(lastRecordId).size() > 0 && safeToReenqueue()) {
            largeDV newQueueable = new largeDV(lastRecordId);
            System.enqueueJob(newQueueable);
        }
    } 
   






    //helper method
    private List<Account> getRecordsToProcess(id offsetId){
        String stringQuery = '';
        stringQuery +='SELECT id,Name ';
        stringQuery +='FROM Account ';
        this.offsetId = offsetId;
        if(offsetId  != null){
            stringQuery +='WHERE Id > :offsetId ';
        }
       // stringQuery += 'WITH SECURITY_ENFORCED ';
        stringQuery +='ORDER BY ID ASC ';
        stringQuery +='LIMIT :chunkSize';
        system.debug(stringQuery);
        return DATABASE.query(stringQuery);
    }





    private Boolean safeToReenqueue() {
        return Limits.getLimitQueueableJobs() > Limits.getQueueableJobs(); //compare if the stack has space to new Que
    }
}
