/*
Enables developers to use a common interface to build loosely 
coupled integrations between Apex classes or triggers, even for
code in separate packages. Agreeing upon a common interface enables
developers from different companies or different departments to build 
upon one another’s solutions. 
Implement this interface to enable the broader community, which 
might have different solutions than the ones you had in mind, to extend your code’s functionality.

*/


public with sharing class CallableExSample implements callable {
   
    String concatStrings(String stringValue) {
        return stringValue + stringValue;
      }
    Decimal multiplyNumbers(Decimal decimalValue) {
        return decimalValue * decimalValue;
    }

   

  public Object call(STRING action ,  MAP<STRING,Object> args){
      switch on action {
          when 'concateString'{
              return this.concatStrings((STRING)args.get('STRING'));
          }
          when 'multiplyNumbers' {
            return this.multiplyNumbers((Decimal)args.get('decimalValue'));
          }
          when else {
            throw new ExtensionMalformedCallException('Method not implemented');
          }
      }
  }

class ExtensionMalformedCallException  extends Exception {}
}


/*
To call callable method 

      String extensionClass = 'Extension'; // Typically set via configuration
      Decimal decimalTestValue = 10;

            Callable extension = (Callable) Type.forName(extensionClass).newInstance();
            Decimal result = (Decimal) 
            extension.call('multiplyNumbers', new Map<String, Object> { 
                                                                        'decimalValue' => decimalTestValue
                                                                        });



*/