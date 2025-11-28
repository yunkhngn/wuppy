import SwiftUI

extension JobStatus {
    var localizedName: LocalizedStringKey {
        switch self {
        case .draft: return "job_status_draft"
        case .negotiating: return "job_status_negotiating"
        case .inProgress: return "job_status_in_progress"
        case .review: return "job_status_review"
        case .waitingPayment: return "job_status_waiting_payment"
        case .paid: return "job_status_paid"
        case .canceled: return "job_status_canceled"
        case .failed: return "job_status_failed"
        case .scammed: return "job_status_scammed"
        }
    }
}

extension JobType {
    var localizedName: LocalizedStringKey {
        switch self {
        case .development: return "job_type_development"
        case .design: return "job_type_design"
        case .videoEditing: return "job_type_video_editing"
        case .music: return "job_type_music"
        case .other: return "job_type_other"
        }
    }
}

extension BillingType {
    var localizedName: LocalizedStringKey {
        switch self {
        case .fixedPrice: return "billing_type_fixed_price"
        case .hourly: return "billing_type_hourly"
        }
    }
}

extension DebtRole {
    var localizedName: LocalizedStringKey {
        switch self {
        case .iOwe: return "debt_role_i_owe"
        case .theyOweMe: return "debt_role_they_owe_me"
        }
    }
}

extension TransactionType {
    var localizedName: LocalizedStringKey {
        switch self {
        case .income: return "transaction_type_income"
        case .expense: return "transaction_type_expense"
        }
    }
}
