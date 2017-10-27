<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    xmlns:mx="meteorix.com">
    
    <xsl:param name="emp_id"/>
    <xsl:param name="input"/>
    <xsl:param name="award_period_amount"/>
    <xsl:param name="award_period_start_date"/>
    <xsl:param name="award_period_end_date"/>
    <xsl:param name="award_memo_code"/>
    <xsl:param name="period_end_date"/>
    <xsl:param name="run_category"/>
    
    <xsl:template match="/">
        
        <env:Envelope
            xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <env:Body>
                <wd:Submit_Payroll_Input_Request
                    xmlns:wd="urn:com.workday/bsvc"
                    wd:version="v26.0">
                    <wd:Payroll_Input_Data>
                        
                        <wd:Batch_ID> <xsl:value-of select="concat('WSBatch',format-dateTime(current-dateTime(),'[Y01][M01][D01]'))"/></wd:Batch_ID>
                        
                        <wd:Ongoing_Input>true</wd:Ongoing_Input>
                        
                        <xsl:choose>
                            <xsl:when test="$period_end_date != '' and $period_end_date &gt; mx:formatDate($award_period_start_date)">
                                <wd:Start_Date><xsl:value-of  select="xsd:date($period_end_date) + xsd:dayTimeDuration('P1D')"/></wd:Start_Date>
                            </xsl:when>
                            <xsl:otherwise>
                                <wd:Start_Date><xsl:value-of  select="xsd:date(mx:formatDate($award_period_start_date))"/></wd:Start_Date>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <wd:End_Date><xsl:value-of select="xsd:date(mx:formatDate($award_period_end_date))"/></wd:End_Date>
                        
                        <wd:Run_Category_Reference>
                            <wd:ID wd:type="Run_Category_ID">
                                <xsl:value-of select="$run_category"/>
                            </wd:ID>
                        </wd:Run_Category_Reference>
                        
                        <wd:Worker_Reference>
                            <wd:ID wd:type="Employee_ID"><xsl:value-of select="$emp_id"/></wd:ID>
                        </wd:Worker_Reference>
                        
                        <wd:Earning_Reference>
                            <wd:ID wd:type="Earning_Code"><xsl:value-of select="$award_memo_code" /></wd:ID>
                        </wd:Earning_Reference>
                        
                        <wd:Amount><xsl:value-of select="$award_period_amount"/></wd:Amount>
                        
                        <wd:Adjustment>false</wd:Adjustment>
                        
                    </wd:Payroll_Input_Data>
                </wd:Submit_Payroll_Input_Request>
            </env:Body>
        </env:Envelope>
        
    </xsl:template>
    
    <xsl:function name="mx:formatDate">
        <xsl:param name="inDate" />
        
        <xsl:variable name="month">
            <xsl:value-of select="substring-before($inDate,'/')"/>
        </xsl:variable>
        <xsl:variable name="dayandyear">
            <xsl:value-of select="substring-after($inDate,'/' )"/>
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:value-of select="substring-before($dayandyear,'/' )"/>
        </xsl:variable>
        <xsl:variable name="year">
            <xsl:value-of select="substring-after($dayandyear,'/' )"/>
        </xsl:variable>
        
        <xsl:variable name="mm">
            <xsl:choose>
            <xsl:when test="$month &lt; 10">
                <xsl:value-of select="concat('0',$month)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$month"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dd">
            <xsl:choose>
                <xsl:when test="$day &lt; 10">
                    <xsl:value-of select="concat('0',$day)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$day"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        
        <xsl:value-of select="concat($year,'-',$mm,'-',$dd)" />        
        
    </xsl:function>
    
</xsl:stylesheet>