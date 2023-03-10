//
//  SqlDsl.swift
//  
//
//  Created by mc on 2022.12.12.
//

import Foundation
import Statement
import StatementSQLite

struct SqlDsl {
    
    func sample00() {
        let entity = Expression()
        let name = try XCTUnwrap(entity["name"])
        
        let statement = SQLiteStatement(
            .SELECT(
                .column(name)
            ),
            .FROM_TABLE(Expression.self),
            .ORDER_BY(
                .column(name, op: .desc)
            )
        )
       
        let s = statement.render()
        print(s)
        
        let expected = """
        SELECT name
        FROM expression
        ORDER BY name DESC;
        """
        
        print(s == expected)
    }
    
    func sample01() {
        
//        let expressionId: Int = 123
//        let languageCode: LanguageCode? = .en
//        let regionCode: RegionCode? = .us
//        
//        let a = SQLiteStatement(
//            .SELECT(
//                    .column(Translation["id"]!),
//                    .column(Translation["expression_id"]!),
//                    .column(Translation["language_code"]!),
//                    .column(Translation["region_code"]!),
//                    .column(Translation["value"]!)
//                ),
//                .FROM_TABLE(Translation.self),
//                .WHERE(
//                    .AND(
//                        .comparison(Translation.expressionID, .equal(expressionID)),
//                        .unwrap(languageCode, transform: { .comparison(Translation["language_code"]!, .equal($0.rawValue)) }),
//                        .unwrap(regionCode, transform: { .comparison(Translation["region_code"]!, .equal($0.rawValue)) }),
//                        .if(languageCode != nil && regionCode == nil, .logical(Translation.region, .isNull))
//                    )
//                )
//        )
        
    }
    
}

