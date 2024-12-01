public with sharing class MergeLocation {

    public static List<Location__c> mergeLocations(List<Location__c> locationList) {
        // Map to store unique locations using the Name as the key
        Map<String, Location__c> uniqueLocations = new Map<String, Location__c>();

        for (Location__c loc : locationList) {
            String locName = loc.Name;

            if (uniqueLocations.containsKey(locName)) {
                // Duplicate found, merge fields
                Location__c existingLoc = uniqueLocations.get(locName);
                
                // Merge non-null fields from loc into existingLoc
                Map<String, Object> locFields = loc.getPopulatedFieldsAsMap();
                for (String fieldName : locFields.keySet()) {
                    // Skip key fields like Id and Name
                    if (fieldName == 'Id' || fieldName == 'Name') {
                        continue;
                    }

                    Object existingValue = existingLoc.get(fieldName);
                    Object newValue = loc.get(fieldName);

                    // If the existing value is null and new value is not null, update it
                    if (existingValue == null && newValue != null) {
                        existingLoc.put(fieldName, newValue);
                    }
                    // If both have values, you can decide whether to overwrite or keep existing
                    // For simplicity, we'll keep the existing value
                }
            } else {
                // Unique location, add to the map
                uniqueLocations.put(locName, loc);
            }
        }

        // Return the list of unique locations
        return uniqueLocations.values();
    }
}
