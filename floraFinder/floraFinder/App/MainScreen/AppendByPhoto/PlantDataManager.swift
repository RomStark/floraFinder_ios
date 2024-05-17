//
//  PlantDataManager.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//

import Foundation


final class PlantDataManager {
    private var plantsIdToName: [String: String] = [:]
    static let shared = PlantDataManager()
    private init() {
        getPlantsIdToName()
    }
    
    private func getPlantsIdToName() {
        if let path = Bundle.main.path(forResource: "plantnet300K_species_names", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

                if let jsonDictionary = jsonResult as? [String: String] {
                    plantsIdToName = jsonDictionary
                    if let value = jsonDictionary["1355868"] {
                        print("Value for key 1355868: \(value)")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getNameBy(id index: String) -> String? {
        return plantsIdToName[index]
        }
    
    func getIdBy(idx index: Int) -> String {
            return plantsIdx[index]
        }
    
    private let plantsIdx = ["1355920", "1355932", "1355955", "1355959", "1355978", "1356003",
                                   "1356075", "1356076", "1356138", "1356279", "1356309", "1356380",
                                   "1356816", "1356847", "1357330", "1357331", "1357681", "1357682",
                                   "1358101", "1358102", "1358103", "1358105", "1358108", "1358119",
                                   "1358127", "1358132", "1358193", "1358365", "1358608", "1358690",
                                   "1358691", "1358695", "1358699", "1358700", "1358701", "1358748",
                                   "1358749", "1358750", "1358755", "1358759", "1358760", "1359060",
                                   "1359064", "1359197", "1359331", "1359332", "1359359", "1359488",
                                   "1359497", "1359505", "1359508", "1359510", "1359513", "1359514",
                                   "1359517", "1359518", "1359519", "1359521", "1359523", "1359524",
                                   "1359525", "1359526", "1359528", "1359530", "1392254", "1392361",
                                   "1392365", "1392418", "1392475", "1392601", "1392653", "1392654",
                                   "1392658", "1392689", "1392690", "1392691", "1392695", "1392730",
                                   "1393241", "1393242", "1393294", "1393393", "1393414", "1393416",
                                   "1393418", "1393423", "1393425", "1393449", "1393450", "1393465",
                                   "1393466", "1393537", "1393614", "1393654", "1393656", "1393725",
                                   "1393789", "1393792", "1393796", "1393846", "1393933", "1393945",
                                   "1393965", "1393967", "1393980", "1394378", "1394383", "1394394",
                                   "1394396", "1394399", "1394401", "1394404", "1394405", "1394420",
                                   "1394453", "1394454", "1394455", "1394460", "1394504", "1394508",
                                   "1396133", "1396134", "1396159", "1396823", "1396824", "1396842",
                                   "1396843", "1396858", "1396869", "1397208", "1397209", "1397268",
                                   "1397269", "1397305", "1397311", "1397312", "1397351", "1397379",
                                   "1397387", "1397403", "1397407", "1397408", "1397420", "1397491",
                                   "1397510", "1397514", "1397515", "1397550", "1397551", "1397556",
                                   "1397585", "1397598", "1397613", "1397841", "1397959", "1398041",
                                   "1398111", "1398125", "1398128", "1398130", "1398178", "1398196",
                                   "1398274", "1398326", "1398333", "1398355", "1398444", "1398447",
                                   "1398469", "1398513", "1398515", "1398526", "1398805", "1399063",
                                   "1399157", "1399338", "1399384", "1399783", "1399804", "1399920",
                                   "1400060", "1400080", "1400081", "1400096", "1400100", "1400110",
                                   "1401216", "1401222", "1401737", "1402303", "1402423", "1402433",
                                   "1402464", "1402576", "1402811", "1402920", "1402921", "1402924",
                                   "1402925", "1402926", "1403272", "1403826", "1403967", "1404481",
                                   "1404745", "1404776", "1405061", "1405252", "1405641", "1405653",
                                   "1405685", "1405686", "1406426", "1407077", "1407379", "1407873",
                                   "1407874", "1408034", "1408037", "1408041", "1408045", "1408066",
                                   "1408071", "1408468", "1408490", "1408557", "1408657", "1408688",
                                   "1408718", "1408738", "1408774", "1408788", "1408869", "1408874",
                                   "1408979", "1409185", "1409191", "1409195", "1409214", "1409215",
                                   "1409216", "1409238", "1409239", "1409283", "1409292", "1409296",
                                   "1409550", "1409551", "1409552", "1409642", "1409839", "1409918",
                                   "1410024", "1410025", "1410147", "1410168", "1411423", "1412337",
                                   "1412344", "1412368", "1412410", "1412412", "1412413", "1412418",
                                   "1412444", "1412445", "1412595", "1412596", "1412659", "1412661",
                                   "1412662", "1412663", "1412697", "1412698", "1412699", "1412740",
                                   "1412745", "1412831", "1412833", "1412834", "1412888", "1412889",
                                   "1412946", "1412992", "1413002", "1413013", "1413391", "1413751",
                                   "1413752", "1413753", "1413755", "1413757", "1413832", "1413835",
                                   "1414057", "1414058", "1414272", "1414275", "1414397", "1414903",
                                   "1415584", "1416420", "1416509", "1417117", "1417506", "1417546",
                                   "1417900", "1417916", "1418033", "1418061", "1418084", "1418102",
                                   "1418140", "1418146", "1418191", "1418192", "1418295", "1418345",
                                   "1418475", "1418545", "1418546", "1418547", "1418563", "1418576",
                                   "1418653", "1418655", "1418659", "1418665", "1418732", "1418984",
                                   "1419077", "1419086", "1419091", "1419112", "1419115", "1419173",
                                   "1419197", "1419334", "1419352", "1419595", "1419598", "1419612",
                                   "1419713", "1419720", "1419807", "1419864", "1419874", "1419923",
                                   "1419924", "1419942", "1419949", "1420092", "1420288", "1420364",
                                   "1420365", "1420496", "1420544", "1420653", "1420700", "1420767",
                                   "1420781", "1420787", "1420792", "1420795", "1420796", "1420863",
                                   "1420896", "1420929", "1420931", "1421001", "1421011", "1421021",
                                   "1421026", "1421107", "1422105", "1422636", "1422712", "1422721",
                                   "1423286", "1423469", "1423633", "1423932", "1424003", "1424005",
                                   "1424377", "1425433", "1425899", "1427043", "1427659", "1427821",
                                   "1428059", "1430280", "1430287", "1430515", "1431222", "1431925",
                                   "1432545", "1432783", "1432786", "1432824", "1433158", "1433176",
                                   "1433496", "1434011", "1434232", "1434249", "1434258", "1434267",
                                   "1434320", "1434326", "1434383", "1434584", "1434594", "1434712",
                                   "1435225", "1435228", "1435260", "1435709", "1435714", "1436922",
                                   "1436923", "1437724", "1438033", "1438041", "1438043", "1438045",
                                   "1438049", "1438052", "1438056", "1438352", "1438354", "1438358",
                                   "1438616", "1438868", "1439145", "1439703", "1440273", "1440412",
                                   "1440416", "1440423", "1440425", "1440440", "1440446", "1440476",
                                   "1441099", "1441349", "1441375", "1441410", "1442541", "1442833",
                                   "1442865", "1442930", "1444049", "1444156", "1444195", "1444216",
                                   "1447962", "1449139", "1449149", "1453004", "1455408", "1460343",
                                   "1463177", "1464023", "1464054", "1464075", "1464086", "1464088",
                                   "1464459", "1464567", "1465016", "1465026", "1465149", "1465170",
                                   "1470435", "1486475", "1486501", "1486655", "1488001", "1488026",
                                   "1488171", "1488206", "1488285", "1491513", "1494482", "1497434",
                                   "1497630", "1497667", "1503981", "1506976", "1513142", "1513780",
                                   "1514627", "1516297", "1518683", "1522375", "1522377", "1529081",
                                   "1529084", "1529107", "1529124", "1529128", "1529148", "1529179",
                                   "1529205", "1529212", "1529242", "1529265", "1529305", "1529328",
                                   "1542499", "1550658", "1550692", "1550785", "1550799", "1560405",
                                   "1580985", "1600531", "1608003", "1617292", "1617904", "1618100",
                                   "1618570", "1618661", "1638998", "1643184", "1643341", "1643349",
                                   "1643491", "1643553", "1643690", "1643819", "1643866", "1643887",
                                   "1644145", "1644223", "1646149", "1663381", "1667445", "1711751"]
}
