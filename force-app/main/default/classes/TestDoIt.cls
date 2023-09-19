public class TestDoIt {
    
    public Static Void PrintIt(){
        
        String ss='123456,7890,123456789,123456fg67';
            
            List<String> list1 = new List<String>();
        
        list1=ss.split(',');
        
        System.debug(list1);
        

        
        for(String con: list1)
        {
            if(!con.isNumeric())
             System.debug(con);
        }
        
    }

}