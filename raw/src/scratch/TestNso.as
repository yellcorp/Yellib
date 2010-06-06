package scratch
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.xml.nso.NamespaceOptimizer;


public class TestNso extends ConsoleApp
{
    public function TestNso()
    {
        super();
        run();
    }

    private function run():void
    {
        var nso:NamespaceOptimizer = new NamespaceOptimizer();
        trace(nso.optimize(getTestDoc1()));
    }

    private function getTestDoc1():XML
    {
        return <e:Envelope xmlns:s="http://epg.foxtel.com.au/schema" xmlns:e="http://schemas.xmlsoap.org/soap/envelope/">
  <e:Header attribute="test">
    <s:SecurityHeader>
      <s:Code>bae4e7</s:Code>
      <s:Code>c263a851-f</s:Code>
      <s:Code>b85b5aee-485</s:Code>
      <s:Code>3ec1fba0-24</s:Code>
    </s:SecurityHeader>
  </e:Header>
  <e:Body>
    <s:SearchEventsIn>
      <s:Bouquet>
        <s:BouquetId xmlns:types="http://epg.foxtel.com.au/schema">25191</s:BouquetId>
        <s:SubBouquetId xmlns:types="http://epg.foxtel.com.au/schema">17</s:SubBouquetId>
      </s:Bouquet>
      <s:StateId>2</s:StateId>
      <s:DateRange>
        <s:StartDate xmlns:types="http://epg.foxtel.com.au/schema">2009-04-06T05:44:18.609Z</s:StartDate>
        <s:EndDate xmlns:types="http://epg.foxtel.com.au/schema">2009-04-06T08:05:45.609Z</s:EndDate>
      </s:DateRange>
      <s:ExtendedSearchInd>false</s:ExtendedSearchInd>
      <s:Channels>
        <s:Id>1</s:Id>
        <s:Id>17</s:Id>
        <s:Id>19</s:Id>
        <s:Id>18</s:Id>
        <s:Id>8</s:Id>
        <s:Id>222</s:Id>
        <s:Id>6</s:Id>
        <s:Id>22</s:Id>
        <s:Id>20</s:Id>
        <s:Id>97</s:Id>
        <s:Id>21</s:Id>
        <s:Id>90</s:Id>
        <s:Id>91</s:Id>
        <s:Id>87</s:Id>
        <s:Id>122</s:Id>
        <s:Id>23</s:Id>
      </s:Channels>
      <s:IsSeriesLinkStart>false</s:IsSeriesLinkStart>
      <s:InProgressInd>true</s:InProgressInd>
      <s:StartRecordNbr>60</s:StartRecordNbr>
      <s:NbrRecordsRequested>60</s:NbrRecordsRequested>
    </s:SearchEventsIn>
  </e:Body>
</e:Envelope>;
        }

        private function getTestDoc2():XML
        {
            return <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <ns1:GetEventDetailsOut xmlns:ns1="http://epg.foxtel.com.au/schema">
      <ns1:EventDetail xsi:type="ns1:EventDetail" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <ns1:ProgramId>000000202270</ns1:ProgramId>
        <ns1:EventId>25900866</ns1:EventId>
        <ns1:ProgramTitle>Bewitched</ns1:ProgramTitle>
        <ns1:ChannelId>1</ns1:ChannelId>
        <ns1:ScheduledDate>2009-04-06T16:05:00.000+10:00</ns1:ScheduledDate>
        <ns1:Duration>25</ns1:Duration>
        <ns1:EpisodeTitle>The Catnapper</ns1:EpisodeTitle>
        <ns1:Audio>Stereo</ns1:Audio>
        <ns1:ParentalRating>G</ns1:ParentalRating>
        <ns1:WidescreenInd>false</ns1:WidescreenInd>
        <ns1:ClosedCaptionInd>false</ns1:ClosedCaptionInd>
        <ns1:SubtitledInd>false</ns1:SubtitledInd>
        <ns1:LiveInd>false</ns1:LiveInd>
        <ns1:PremiereInd>false</ns1:PremiereInd>
        <ns1:SeriesLink>88683</ns1:SeriesLink>
        <ns1:SeriesLinkStartInd>false</ns1:SeriesLinkStartInd>
        <ns1:SeriesLinkEndInd>false</ns1:SeriesLinkEndInd>
        <ns1:Actor>Elizabeth Montgomery</ns1:Actor>
        <ns1:Actor>Dick York</ns1:Actor>
        <ns1:Actor>Agnes Moorehead</ns1:Actor>
        <ns1:Actor>David White</ns1:Actor>
        <ns1:MergedSynopsis>S2, Ep33. The Catnapper: A detective from the past has tracked Samantha down and knows that she is a witch, and threatens to expose her to the world.</ns1:MergedSynopsis>
        <ns1:ExtendedSynopsis>A detective from the past has tracked Samantha down and knows that she is a witch, and threatens to expose her to the world.</ns1:ExtendedSynopsis>
        <ns1:SeriesNumber>2</ns1:SeriesNumber>
        <ns1:EpisodeNumber>33</ns1:EpisodeNumber>
        <ns1:GenreCode>02</ns1:GenreCode>
        <ns1:SubGenreCode>2</ns1:SubGenreCode>
        <ns1:WebLink>
          <ns1:Title>Fan Site</ns1:Title>
          <ns1:Url>http://www.bewitched.net/</ns1:Url>
        </ns1:WebLink>
        <ns1:WebLink>
          <ns1:Title>Episode Guide</ns1:Title>
          <ns1:Url>http://epguides.com/Bewitched/</ns1:Url>
        </ns1:WebLink>
        <ns1:WebLink>
          <ns1:Title>IMDB</ns1:Title>
          <ns1:Url>http://www.imdb.com/title/tt0057733/</ns1:Url>
        </ns1:WebLink>
        <ns1:SimilarId>100362</ns1:SimilarId>
        <ns1:SimilarId>134059</ns1:SimilarId>
        <ns1:SimilarId>134184</ns1:SimilarId>
        <ns1:SimilarId>100273</ns1:SimilarId>
        <ns1:SimilarId>100305</ns1:SimilarId>
        <ns1:YearOfProduction>1965</ns1:YearOfProduction>
        <ns1:CountryOfOrigin>United States</ns1:CountryOfOrigin>
        <ns1:Language>English</ns1:Language>
        <ns1:ColourType>Colour</ns1:ColourType>
      </ns1:EventDetail>
    </ns1:GetEventDetailsOut>
  </soapenv:Body>
</soapenv:Envelope>
            ;
        }
    }
}
