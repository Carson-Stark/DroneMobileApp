//
//  Network.swift
//  MAVSDK_Swift_Example
//
//  Created by Carson Stark on 9/4/23.
//

import Foundation

class TCPClient: NSObject, ObservableObject, StreamDelegate {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    var timer: Timer?
    @Published var isConnected = false
    
    let reconnectDelay: TimeInterval = 5.0
    
    let host = "your-host-ip"
    let port = 12345
    
    @Published var missionName = "None"
    @Published var currItemStartTime: Date = Date()
    @Published var missionStartTime: Date = Date();
    @Published var totalMissionItems = 0
    @Published var missionItems: [String] = ["-", "-", "-"]
    
    override init() {
        super.init()
        connectToServer()
    }
    
    func connectToServer() {
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        inputStream?.delegate = self
        outputStream?.delegate = self

        inputStream?.schedule(in: .current, forMode: .default)
        outputStream?.schedule(in: .current, forMode: .default)
        
        inputStream?.open()
        outputStream?.open()
    }
    
    func getDateFromString(strDate: String, format: String = "HH:mm:ss") -> Date? {
        print(strDate)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        let date = formatter.date(from: strDate)
        let opDate = date!
        return opDate
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            let responses = readResponse();
            if responses == nil {
                break;
            }
            
            for resp in responses! {
                let args = resp.split(separator: "\n")
                if args.count >= 8 && args[0] == "Mission:" {
                    print("Mission data recieved")
                    missionName = String(args[1])
                    totalMissionItems = Int(args[2]) ?? 0
                    missionStartTime = getDateFromString(strDate: String(args[3])) ?? Date()
                    print(missionStartTime)
                    currItemStartTime = getDateFromString(strDate: String(args[4])) ?? Date()
                    print(currItemStartTime)
                    missionItems[0] = String(args[5])
                    missionItems[1] = String(args[6])
                    missionItems[2] = String(args[7])
                }
                else {
                    MessageViewModel.shared.message = resp
                }
            }
            
        case .hasSpaceAvailable:
            if !isConnected {
                print("Connected to the server")
                isConnected = true
                startHeartbeatTimer()
            }
        case .errorOccurred:
            print("Error occurred on stream")
            disconnect()
        default:
            break
        }
    }
    
    func sendMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else {
            print("Error encoding message")
            return
        }
        
        _ = data.withUnsafeBytes { outputStream?.write($0.baseAddress!.assumingMemoryBound(to: UInt8.self), maxLength: data.count) }
    }
    
    func readResponse() -> [String]? {
        var buffer = [UInt8](repeating: 0, count: 1024)
        let bytesRead = inputStream?.read(&buffer, maxLength: buffer.count)
        if let bytesRead = bytesRead, bytesRead > 0 {
            let resp = String(bytes: buffer, encoding: .utf8)
            return resp?.components(separatedBy: ",")
        }
        return nil
    }
    
    func sendHeartbeat() {
        print(isConnected)
        sendMessage("Client Heartbeat")
    }

    func disconnect() {
        print("Disconnected from the server")
        isConnected = false
        inputStream?.close()
        outputStream?.close()
        timer?.invalidate()
        reconnectAfterDelay()
    }
    
    func reconnectAfterDelay() {
        print("Attempting to reconnect after \(reconnectDelay) seconds")
        timer = Timer.scheduledTimer(withTimeInterval: reconnectDelay, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.connectToServer()
        }
    }

    func startHeartbeatTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.sendHeartbeat()
        }
    }
}

