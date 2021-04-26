param
(
    [Parameter (Mandatory = $true)]
    $Category,
    [Parameter (Mandatory = $true)]
    $Title,
    [Parameter (Mandatory = $true)]
    $Subtitle,
    [Parameter (Mandatory = $true)]
    $Text,
    [Parameter (Mandatory = $false)]
    $Fact1Name,
    [Parameter (Mandatory = $false)]
    $Fact1Value,
    [Parameter (Mandatory = $false)]
    $Fact2Name,
    [Parameter (Mandatory = $false)]
    $Fact2Value,
    [Parameter (Mandatory = $false)]
    $Fact3Name,
    [Parameter (Mandatory = $false)]
    $Fact3Value,
    [Parameter (Mandatory = $false)]
    $LinkName,
    [Parameter (Mandatory = $false)]
    $LinkValue
)


# teams channel incoming webhook
$uri = "https://xxxxx.webhook.office.com/webhookb2/xxxxxxxxxxx/IncomingWebhook/xxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxx"

#$servicePrincipalConnection = Get-AutomationConnection -Name "AzureRunAsConnection" -ErrorAction Stop
$notificationColour = "b830e6"

<#
$Category = "INFO"
$Title = "This is a test"
$Subtitle = "A notification has been received by an Azure Automation runbook. "
$Text = "Please review the details: "
$Fact1Name = "Job Id"
$Fact1Value = "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx"
$Fact2Name = "Received"
$Fact2Value = Get-Date
$Fact3Name = "Other Id"
$Fact3Value = "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx"
$LinkName = "Link to x"
$LinkValue = "https://endpoint.microsoft.com/"
#>

$Facts = if($Fact1Name) {
    @"
,
        "facts": [{
            "name": "$Fact1Name",
            "value": "$Fact1Value"
        }$(if($Fact2Name){@"
    ,{
            "name": "$Fact2Name",
            "value": "$Fact2Value"
        }
"@
} else {""})

$(if($Fact3Name){@"
    ,{
            "name": "$Fact2Name",
            "value": "$Fact2Value"
        }
"@
} else {""})$(if($LinkName) {
    @"
,{
            "name": "$LinkName",
            "value": "$LinkValue"
        }
"@
} else {
    ""
})]
"@
}

$linkButton = if($LinkName){@"
    ,"potentialAction": [{
        "@type": "OpenUri",
        "name": "$LinkName",
        "targets": [{
            "os": "default",
            "uri": "$LinkValue"
        }]
    }]
"@
} else {""}


$body = @"
{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "$notificationColour",
    "summary": "Automation notification: $Category - $Title",
    "sections": [{
        "activityTitle": "Automation notification: $Category - $Title",
        "activitySubtitle": "$Subtitle",
        "activityText": "$Text",
        "activityImage": "",
        "markdown": true
        $Facts
    }]$linkButton
}
"@

$response = Invoke-WebRequest -Method Post -Uri $uri -Body $body -UseBasicParsing

 
