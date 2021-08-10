//
//  ApiError.swift
//  MatchReminder
//
//  Created by Lionel Smith on 10/08/2021.
//

import Foundation

enum ApiError: Error {
  case notFound // 404
  case serverError // 5xx
  case requestError // 4xx
  case jsonError
  case couldNotConnectToHost
}
