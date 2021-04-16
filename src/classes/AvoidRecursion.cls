public class AvoidRecursion {
 	 Public static boolean runBefore = false;
     public static boolean runAfter = false;
     private static Integer i =0;
     private static Integer j =0;
    private static boolean firstRun = true;
    public static boolean isFirstRun(){
        if(firstRun){
            firstRun = false;
            return true;
        }else{
            return firstRun;
        }
    }
    private static boolean accTriggerfirstRun = true;
    public static boolean isaccTriggerfirstRun(){
        if(accTriggerfirstRun){
            accTriggerfirstRun = false;
            return true;
        }else{
            return accTriggerfirstRun;
        }
    }
     public static boolean hasRunBeforeAlready(){
         //System.debug('Invoked for the First Time:::');        
                if(runBefore){
                    ++i;
                    //System.debug('Before returning Called hasRunBeforeAlready for i:::'+i+''+runBefore);
                    return runBefore;
                    
                }else{
                  runBefore = true;
                  ++j;  
                  //System.debug('Before returning Called hasRunBeforeAlready for J:::'+j+''+runBefore);
                  return false;
                }
    }
        
  public static boolean hasRunAfterAlready(){
        //System.debug('AvoidRecursion Method ::::hasRunAfterAlready:::'+runAfter);
                if(runAfter){
                   return runAfter;
                }else{
                    runAfter = true;
                    return false;
               
                }
    }
}