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
$uri = "https://xxxxx.webhook.office.com/webhookb2/xxxxxxxxxxx/IncomingWebhook/xxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxx"

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

$jsonBase = [ordered]@{
    "@type" = "MessageCard";
    "@context" = "http://schema.org/extensions";
    "themeColor" = "$notificationColour";
    "summary" = "Automation notification: $Category - $Title";
}


$facts = New-Object System.Collections.ArrayList

if ($Fact1Name) {
    $facts.Add([ordered]@{
        "name" = "$Fact1Name";
        "value" = "$Fact1Value";
    })
}

if ($Fact2Name) {
    $facts.Add([ordered]@{
        "name" = "$Fact2Name";
        "value" = "$Fact2Value";
    })
}

if ($Fact3Name) {
    $facts.Add([ordered]@{
        "name" = "$Fact3Name";
        "value" = "$Fact3Value";
    })
}

if ($LinkName) {
    $potentialAction = New-Object System.Collections.ArrayList

    $potentialActionTargets = New-Object System.Collections.ArrayList

    $potentialActionTargets.Add([ordered]@{
        "os" = "default";
        "uri" = "$LinkValue";
    })

    $potentialAction.Add([ordered]@{
        "@type" = "OpenUri";
        "name" = "$LinkName";
        "targets" = $potentialActionTargets
    })

    $facts.Add([ordered]@{
        "name" = "$LinkName";
        "value" = "$LinkValue";
    })

    $jsonBase.Add("potentialAction",$potentialAction)
}

$sections = New-Object System.Collections.ArrayList

$sections.Add([ordered]@{
    "activityTitle" = "Automation notification: $Category - $Title"
    "activitySubtitle" = "$Subtitle";
    "activityText" = "$Text";
    "activityImage" = "";
    "markdown" = $true;
    "facts" = $facts;
})

$jsonBase.Add("sections",$sections)

$body = $jsonBase | Convertto-Json -Depth 10

$response = Invoke-WebRequest -Method Post -Uri $uri -Body $body -UseBasicParsing
 
