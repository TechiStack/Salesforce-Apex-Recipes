public with sharing class CanTheUser {
    @testVisible
    private static Map<String, Set<String>> accessibleFieldsByObject = new Map<String, Set<String>>();
    @testVisible
    private static Map<String, Set<String>> updatableFieldsByObject = new Map<String, Set<String>>();

    /**
     * @description Internal custom exception class
     */
    public class CanTheUserException extends Exception {
    }

    public enum CrudType {
        CREATE,
        READ,
        EDIT,
        DEL
    }

    public enum FLSType {
        ACCESSIBLE,
        UPDATABLE
    }

    private class PermissionCache implements Cache.CacheBuilder {
   
        public Object doLoad(String objType) {
            return calculateFLS(objType);
        }

    
        public Map<String, Map<FLSType, Boolean>> calculateFLS(string objType) {
            Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(
                new List<String>{ objType }
            );

            Map<String, Map<FLSType, Boolean>> results = new Map<String, Map<FLSType, Boolean>>();
            for (SObjectField field : descResult[0].fields.getMap().values()) {
                DescribeFieldResult fieldDetails = field.getDescribe();
                String fieldKey = String.valueOf(field).toLowerCase();
                results.put(fieldKey, new Map<FLSType, Boolean>());
                results.get(fieldKey)
                    .put(FLSType.ACCESSIBLE, fieldDetails.isAccessible());
                results.get(fieldKey)
                    .put(FLSType.UPDATABLE, fieldDetails.isUpdateable());
            }
            return results;
        }
    }

 
    public static Boolean crud(SObject obj, CrudType permission) {
        switch on permission {
            when CREATE {
                return obj.getSObjectType().getDescribe().isCreateable();
            }
            when READ {
                return obj.getSObjectType().getDescribe().isAccessible();
            }
            when EDIT {
                return obj.getSObjectType().getDescribe().isUpdateable();
            }
            when DEL {
                return obj.getSObjectType().getDescribe().isDeletable();
            }
        }
        return false;
    }

    public static Boolean create(SObject obj) {
        return CanTheUser.crud(obj, CrudType.CREATE);
    }

    public static Boolean read(SObject obj) {
        return CanTheUser.crud(obj, CrudType.READ);
    }

    public static Boolean edit(SObject obj) {
        return CanTheUser.crud(obj, CrudType.EDIT);
    }

    public static Boolean destroy(SObject obj) {
        return CanTheUser.crud(obj, CrudType.DEL);
    }

    public static Boolean flsAccessible(String obj, String field) {
        return getFLSForFieldOnObject(obj, field, FLSType.ACCESSIBLE);
    }

    public static Map<String, Boolean> bulkFLSAccessible(
        String obj,
        Set<String> fields
    ) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, flsAccessible(obj, field));
        }
        return results;
    }

    public static Boolean flsUpdatable(String obj, String field) {
        return getFLSForFieldOnObject(obj, field, FLSType.UPDATABLE);
    }

    public static Map<String, Boolean> bulkFLSUpdatable(
        String obj,
        Set<String> fields
    ) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, flsUpdatable(obj, field));
        }
        return results;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @testVisible
    private static Set<String> memoizeFLSMDC(String objType, FLSType action) {
        List<FieldPermissions> fields = [
            SELECT Id, Field, PermissionsEdit, PermissionsRead, SobjectType
            FROM FieldPermissions
            WHERE SobjectType = :objType
        ];

        if (!CanTheUser.accessibleFieldsByObject.containsKey(objType)) {
            Set<String> accessibleFields = new Set<String>();
            Set<String> updatableFields = new Set<String>();
            for (FieldPermissions field : fields) {
                String[] parts = field.Field.split('\\.');
                if (field.PermissionsRead) {
                    accessibleFields.add(parts[1].toLowerCase());
                }
                if (field.PermissionsEdit) {
                    updatableFields.add(parts[1].toLowerCase());
                }
            }
            CanTheUser.accessibleFieldsByObject.put(objType, accessibleFields);
            CanTheUser.updatableFieldsByObject.put(objType, updatableFields);
        }

        if (action == CanTheUser.FLSType.ACCESSIBLE) {
            return CanTheUser.accessibleFieldsByObject.get(objType);
        } else {
            return CanTheUser.updatableFieldsByObject.get(objType);
        }
    }

   
    private static Boolean getFLSForFieldOnObject(
        String obj,
        String field,
        FLSType checkType
    ) {
        Cache.Partition defaultSession = PlatformCacheRecipes.getDefaultPartition(
            PlatformCacheRecipes.PartitionType.SESSION
        );

        Map<String, Map<FLSType, Boolean>> objResults;

        if (new OrgShape().isPlatformCacheEnabled()) {
            objResults = (Map<String, Map<FLSType, Boolean>>) defaultSession
                .get(PermissionCache.class, obj);
        } else {
            objResults = new PermissionCache().calculateFLS(obj);
        }

        Boolean results = objResults.get(field.toLowerCase())?.get(checkType);
        return (results != null && results) ? true : false;
    }
}
