# universal-alarm
## Overview
This app is designed to synchronize alarms across multiple devices using the same account. It ensures seamless integration and real-time updates, allowing users to manage alarms efficiently across platforms such as Android, iOS, and Windows.

---

## Features
1. **Cross-Device Synchronization**  
   - Alarms set on one device are automatically updated on all linked devices.  
   - Real-time updates ensure consistency across platforms.

2. **Customizable Alarms**  
   - Personalize alarm tones, labels, and snooze durations for each device.  
   - Set recurring alarms for daily routines or special events.

3. **Smart Notifications**  
   - Receive reminders on all devices simultaneously.  
   - Push notifications ensure no alarm goes unnoticed.

4. **Cloud-Based Architecture**  
   - Securely store alarm settings in the cloud for instant retrieval and synchronization.

5. **Offline Functionality**  
   - Alarms work even when devices are offline, syncing updates once reconnected.

6. **User-Friendly Interface**  
   - Intuitive design with widgets for quick access to alarm settings.

---

## Technical Details

### Shared Code Between Platforms
- **Core Logic**: Business logic, database management (e.g., SQLite), and web service calls can be shared across platforms using C#.  
- **Interfaces & Dependency Injection**: Use interfaces to define platform-specific functionality (e.g., IAlarmManager) and implement Dependency Injection for flexibility.  


### Alarm Management
- Use **AlarmManager** for Android and **LocalNotification** for iOS to handle alarms effectively, especially when devices are in sleep mode or running other apps.

---