var callCloseTab= function callCloseTab(result) {
            sforce.console.closeTab(result.id);
        }

        function closeTab() {
                    sforce.console.getEnclosingTabId(callCloseTab);
                            }