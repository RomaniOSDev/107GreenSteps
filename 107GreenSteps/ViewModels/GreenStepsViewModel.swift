import Foundation
import Combine
import UserNotifications

final class GreenStepsViewModel: ObservableObject {
    @Published var habits: [EcoHabit] = []
    @Published var actions: [EcoAction] = []
    @Published var goals: [EcoGoal] = []
    @Published var challenges: [EcoChallenge] = []

    var activeHabits: [EcoHabit] { habits.filter(\.isActive) }
    var allHabits: [EcoHabit] { habits }

    var todayActions: [EcoAction] {
        actions.filter { Calendar.current.isDateInToday($0.date) }
    }

    var totalActions: Int { actions.reduce(0) { $0 + $1.quantity } }
    var todayActionsCount: Int { todayActions.reduce(0) { $0 + $1.quantity } }

    var todayProgress: Double {
        let totalGoal = activeHabits.reduce(0) { $0 + $1.dailyGoal }
        guard totalGoal > 0 else { return 0 }
        return min(Double(todayActionsCount) / Double(totalGoal), 1.0)
    }

    var totalCO2Saved: Double {
        actions.filter { $0.impactUnit == .kg }.reduce(0) { $0 + $1.impactSaved }
    }

    var totalWaterSaved: Double {
        actions.filter { $0.impactUnit == .liters }.reduce(0) { $0 + $1.impactSaved }
    }

    var totalPlasticAvoided: Int {
        actions
            .filter { $0.impactUnit == .pieces || $0.impactUnit == .bags || $0.impactUnit == .bottles }
            .reduce(0) { $0 + Int($1.impactSaved) }
    }

    var streakDays: Int {
        let calendar = Calendar.current
        var date = calendar.startOfDay(for: Date())
        var streak = 0

        while actions.contains(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: date) else { break }
            date = previous
        }
        return streak
    }

    var recentActions: [EcoAction] {
        Array(actions.sorted(by: { $0.date > $1.date }).prefix(20))
    }

    struct WeeklyActivity: Identifiable {
        let id = UUID()
        let day: String
        let count: Int
    }

    var weeklyActivity: [WeeklyActivity] {
        let calendar = Calendar.current
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E"

        return (0..<7).reversed().compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let count = actions
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + $1.quantity }
            return WeeklyActivity(day: formatter.string(from: date), count: count)
        }
    }

    struct CategoryStat: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let count: Int
    }

    var categoryStats: [CategoryStat] {
        let grouped = Dictionary(grouping: actions) { action -> HabitCategory in
            habits.first(where: { $0.id == action.habitId })?.category ?? .other
        }

        return grouped.map { category, groupedActions in
            CategoryStat(
                name: category.rawValue,
                emoji: category.emoji,
                count: groupedActions.reduce(0) { $0 + $1.quantity }
            )
        }.sorted(by: { $0.count > $1.count })
    }

    struct BestDay {
        let date: Date
        let actions: Int
        let impact: Double
    }

    var bestDay: BestDay? {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: actions) { calendar.startOfDay(for: $0.date) }

        let value = grouped.map { date, groupedActions in
            BestDay(
                date: date,
                actions: groupedActions.reduce(0) { $0 + $1.quantity },
                impact: groupedActions.reduce(0) { $0 + $1.impactSaved }
            )
        }.max(by: { $0.actions < $1.actions })

        return value
    }

    func actionsCount(for habitId: UUID) -> Int {
        actions.filter { $0.habitId == habitId }.reduce(0) { $0 + $1.quantity }
    }

    func addHabit(_ habit: EcoHabit) {
        habits.append(habit)
        scheduleReminder(for: habit)
        saveToUserDefaults()
    }

    func updateHabit(_ habit: EcoHabit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        cancelReminder(for: habits[index])
        habits[index] = habit
        scheduleReminder(for: habit)
        saveToUserDefaults()
    }

    func deleteHabit(_ habit: EcoHabit) {
        habits.removeAll { $0.id == habit.id }
        actions.removeAll { $0.habitId == habit.id }
        cancelReminder(for: habit)
        recalculateGoals()
        saveToUserDefaults()
    }

    func toggleActive(_ habit: EcoHabit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].isActive.toggle()
        habits[index].isActive ? scheduleReminder(for: habits[index]) : cancelReminder(for: habits[index])
        saveToUserDefaults()
    }

    func addAction(_ action: EcoAction) {
        actions.append(action)
        recalculateGoals()
        saveToUserDefaults()
    }

    func deleteAction(_ action: EcoAction) {
        actions.removeAll { $0.id == action.id }
        recalculateGoals()
        saveToUserDefaults()
    }

    func updateAction(_ action: EcoAction) {
        guard let index = actions.firstIndex(where: { $0.id == action.id }) else { return }
        actions[index] = action
        recalculateGoals()
        saveToUserDefaults()
    }

    func addGoal(_ goal: EcoGoal) {
        goals.append(goal)
        saveToUserDefaults()
    }

    func deleteGoal(_ goal: EcoGoal) {
        goals.removeAll { $0.id == goal.id }
        saveToUserDefaults()
    }

    func updateGoal(_ goal: EcoGoal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index] = goal
        recalculateGoals()
        saveToUserDefaults()
    }

    private func recalculateGoals() {
        guard !goals.isEmpty else { return }

        for index in goals.indices {
            let goal = goals[index]
            let relevant = actions.filter { $0.impactUnit == goal.unit }
            let current = relevant.reduce(0) { $0 + $1.impactSaved }

            goals[index].currentValue = current
            goals[index].isCompleted = current >= goal.targetValue
        }
    }

    private func scheduleReminder(for habit: EcoHabit) {
        guard habit.isActive, let reminderTime = habit.reminderTime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Daily eco reminder"
        content.body = "Do: \(habit.name) (\(Int(habit.impactPerAction)) \(habit.impactUnit.rawValue))"
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelReminder(for habit: EcoHabit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
    }

    private let habitsKey = "greensteps_habits"
    private let actionsKey = "greensteps_actions"
    private let goalsKey = "greensteps_goals"
    private let challengesKey = "greensteps_challenges"

    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        }
        if let encoded = try? JSONEncoder().encode(actions) {
            UserDefaults.standard.set(encoded, forKey: actionsKey)
        }
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
        if let encoded = try? JSONEncoder().encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: challengesKey)
        }
    }

    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([EcoHabit].self, from: data) {
            habits = decoded
        }
        if let data = UserDefaults.standard.data(forKey: actionsKey),
           let decoded = try? JSONDecoder().decode([EcoAction].self, from: data) {
            actions = decoded
        }
        if let data = UserDefaults.standard.data(forKey: goalsKey),
           let decoded = try? JSONDecoder().decode([EcoGoal].self, from: data) {
            goals = decoded
        }
        if let data = UserDefaults.standard.data(forKey: challengesKey),
           let decoded = try? JSONDecoder().decode([EcoChallenge].self, from: data) {
            challenges = decoded
        }
        if habits.isEmpty {
            loadDemoData()
        }
    }

    private func loadDemoData() {
        let habit1 = EcoHabit(
            id: UUID(),
            name: "Waste sorting",
            category: .waste,
            description: "Separate plastic, glass and paper.",
            impactPerAction: 2.5,
            impactUnit: .kg,
            isActive: true,
            dailyGoal: 1,
            reminderTime: nil,
            isFavorite: true,
            createdAt: Date()
        )
        let habit2 = EcoHabit(
            id: UUID(),
            name: "Skip plastic bags",
            category: .shopping,
            description: "Use reusable shopping bags.",
            impactPerAction: 1.0,
            impactUnit: .bags,
            isActive: true,
            dailyGoal: 1,
            reminderTime: nil,
            isFavorite: false,
            createdAt: Date()
        )
        let habit3 = EcoHabit(
            id: UUID(),
            name: "Save water",
            category: .water,
            description: "Turn off the tap while brushing teeth.",
            impactPerAction: 10.0,
            impactUnit: .liters,
            isActive: true,
            dailyGoal: 2,
            reminderTime: nil,
            isFavorite: false,
            createdAt: Date()
        )
        habits = [habit1, habit2, habit3]

        let action1 = EcoAction(
            id: UUID(),
            habitId: habit1.id,
            habitName: habit1.name,
            impactPerAction: habit1.impactPerAction,
            impactUnit: habit1.impactUnit,
            date: Date().addingTimeInterval(-3600),
            quantity: 1,
            notes: nil,
            location: "Home"
        )
        let action2 = EcoAction(
            id: UUID(),
            habitId: habit2.id,
            habitName: habit2.name,
            impactPerAction: habit2.impactPerAction,
            impactUnit: habit2.impactUnit,
            date: Date().addingTimeInterval(-7200),
            quantity: 1,
            notes: "At supermarket",
            location: "Store"
        )
        actions = [action1, action2]

        goals = [
            EcoGoal(
                id: UUID(),
                name: "Save 50 kg CO2",
                targetValue: 50,
                currentValue: 2.5,
                unit: .kg,
                deadline: Calendar.current.date(byAdding: .month, value: 1, to: Date()),
                isCompleted: false,
                createdAt: Date()
            )
        ]
        saveToUserDefaults()
    }
}
