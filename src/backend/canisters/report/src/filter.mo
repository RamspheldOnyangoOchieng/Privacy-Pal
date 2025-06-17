import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Types "../types";
import Utils "../utils";
import Constants "../constants";

actor class FilterCanister {
    // State variables
    private stable var savedFilters = HashMap.new<Text, Types.Filter>();
    private stable var filterHistory = HashMap.new<Text, Types.FilterHistory>();
    private stable var filterTemplates = HashMap.new<Text, Types.FilterTemplate>();

    // Private helper functions
    private func generateFilterId() : Text {
        "filter_" # Nat.toText(Time.now())
    };

    private func generateTemplateId() : Text {
        "template_" # Nat.toText(Time.now())
    };

    private func validateFilter(filter : Types.Filter) : Bool {
        Utils.isNotEmpty(filter.name) and
        filter.conditions.size() > 0 and
        filter.conditions.size() <= Constants.MAX_FILTER_CONDITIONS
    };

    private func validateTemplate(template : Types.FilterTemplate) : Bool {
        Utils.isNotEmpty(template.name) and
        template.filters.size() > 0 and
        template.filters.size() <= Constants.MAX_TEMPLATE_FILTERS
    };

    private func applyFilter<T>(items : [T], filter : Types.Filter, getField : T -> Text) : [T] {
        Array.filter(items, func(item : T) : Bool {
            let fieldValue = getField(item);
            switch (filter.operator) {
                case (#equals) { fieldValue == filter.value };
                case (#contains) { Text.contains(fieldValue, #text filter.value) };
                case (#startsWith) { Text.startsWith(fieldValue, #text filter.value) };
                case (#endsWith) { Text.endsWith(fieldValue, #text filter.value) };
                case (#greaterThan) { fieldValue > filter.value };
                case (#lessThan) { fieldValue < filter.value };
                case (#between) {
                    let parts = Text.split(fieldValue, #text "-");
                    if (Array.size(parts) == 2) {
                        let start = Array.get(parts, 0);
                        let end = Array.get(parts, 1);
                        switch (start, end) {
                            case (?s, ?e) { fieldValue >= s and fieldValue <= e };
                            case _ { false }
                        }
                    } else {
                        false
                    }
                };
                case (#inList) {
                    let values = Text.split(filter.value, #text ",");
                    Array.some(values, func(v : Text) : Bool { v == fieldValue })
                };
                case (#regex) {
                    // Basic regex matching - can be enhanced with a proper regex library
                    Text.contains(fieldValue, #text filter.value)
                }
            }
        })
    };

    private func sortItems<T>(items : [T], sortBy : Types.SortBy, getField : T -> Text) : [T] {
        let sorted = Array.sort(items, func(a : T, b : T) : Order.Order {
            let fieldA = getField(a);
            let fieldB = getField(b);
            switch (sortBy.direction) {
                case (#ascending) { Text.compare(fieldA, fieldB) };
                case (#descending) { Text.compare(fieldB, fieldA) }
            }
        });
        sorted
    };

    // Public shared functions
    public shared(msg) func createFilter(filter : Types.Filter) : async Result.Result<Text, Text> {
        if (not validateFilter(filter)) {
            return #err(Constants.ERROR_INVALID_FILTER)
        };
        let filterId = generateFilterId();
        let newFilter = {
            id = filterId;
            name = filter.name;
            description = filter.description;
            conditions = filter.conditions;
            operator = filter.operator;
            value = filter.value;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        HashMap.put(savedFilters, Text.equal, filterId, newFilter);
        #ok(filterId)
    };

    public shared(msg) func createTemplate(template : Types.FilterTemplate) : async Result.Result<Text, Text> {
        if (not validateTemplate(template)) {
            return #err(Constants.ERROR_INVALID_TEMPLATE)
        };
        let templateId = generateTemplateId();
        let newTemplate = {
            id = templateId;
            name = template.name;
            description = template.description;
            filters = template.filters;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        HashMap.put(filterTemplates, Text.equal, templateId, newTemplate);
        #ok(templateId)
    };

    public shared(msg) func applyFilterToReports(reports : [Types.Report], filterId : Text) : async Result.Result<[Types.Report], Text> {
        switch (HashMap.get(savedFilters, Text.equal, filterId)) {
            case (?filter) {
                let filteredReports = applyFilter(reports, filter, func(r : Types.Report) : Text { r.title });
                #ok(filteredReports)
            };
            case null { #err(Constants.ERROR_FILTER_NOT_FOUND) }
        }
    };

    public shared(msg) func applyTemplateToReports(reports : [Types.Report], templateId : Text) : async Result.Result<[Types.Report], Text> {
        switch (HashMap.get(filterTemplates, Text.equal, templateId)) {
            case (?template) {
                var filteredReports = reports;
                for (filter in template.filters.vals()) {
                    switch (await applyFilterToReports(filteredReports, filter.id)) {
                        case (#ok(reports)) { filteredReports := reports };
                        case (#err(_)) { return #err(Constants.ERROR_FILTER_APPLICATION_FAILED) }
                    }
                };
                #ok(filteredReports)
            };
            case null { #err(Constants.ERROR_TEMPLATE_NOT_FOUND) }
        }
    };

    public shared(msg) func sortReports(reports : [Types.Report], sortBy : Types.SortBy) : async Result.Result<[Types.Report], Text> {
        let sortedReports = sortItems(reports, sortBy, func(r : Types.Report) : Text { r.title });
        #ok(sortedReports)
    };

    // Query functions
    public query func getFilter(filterId : Text) : async ?Types.Filter {
        HashMap.get(savedFilters, Text.equal, filterId)
    };

    public query func getTemplate(templateId : Text) : async ?Types.FilterTemplate {
        HashMap.get(filterTemplates, Text.equal, templateId)
    };

    public query func getFilters() : async [Types.Filter] {
        let filters = HashMap.entries(savedFilters);
        Array.map(filters, func((id, filter) : (Text, Types.Filter)) : Types.Filter { filter })
    };

    public query func getTemplates() : async [Types.FilterTemplate] {
        let templates = HashMap.entries(filterTemplates);
        Array.map(templates, func((id, template) : (Text, Types.FilterTemplate)) : Types.FilterTemplate { template })
    };

    public query func getFilterHistory(userId : Text) : async [Types.FilterHistory] {
        let history = HashMap.entries(filterHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.FilterHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.FilterHistory)) : Types.FilterHistory { h })
    };
}; 