variable "alarm_count" {
  description = "The number of alarms to create."
  type        = "string"
  default     = 1
}

variable "alarm_description" {
  description = "The description for the alarm."
  type        = "string"
  default     = ""
}

variable "alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account"
  type        = "string"
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  type        = "string"
}

variable "customer_alarms_cleared" {
  description = "Specifies whether alarms will notify customers when returning to an OK status."
  type        = "string"
  default     = false
}

variable "customer_alarms_enabled" {
  description = "Specifies whether alarms will notify customers.  Automatically enabled if lsm_managed is set to false"
  type        = "string"
  default     = false
}

variable "dimensions" {
  description = "The list of dimensions for the alarm's associated metric. For the list of available dimensions see the AWS documentation here."
  type        = "list"
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = "string"
}

variable "metric_name" {
  description = "The name for the alarm's associated metric. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html for supported metrics."
  type        = "string"
}

variable "namespace" {
  description = "The namespace for the alarm's associated metric. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/aws-namespaces.html for the list of namespaces."
  type        = "string"
}

variable "notification_topic" {
  description = "List of SNS Topic ARNs to use for customer notifications."
  type        = "list"
  default     = []
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied."
  type        = "string"
  default     = 60
}

variable "lsm_alarms_enabled" {
  description = "Specifies whether alarms will create a lsm ticket.  Ignored if lsm_managed is set to false"
  type        = "string"
  default     = false
}

variable "lsm_managed" {
  description = "Boolean parameter controlling if instance will be fully managed by lsm support teams, created CloudWatch alarms that generate tickets, and utilize lsm managed SSM documents."
  type        = "string"
  default     = true
}

variable "severity" {
  description = "The desired severity of the created lsm ticket.  Supported values include: standard, urgent, emergency "
  type        = "string"
  default     = "standard"
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  type        = "string"
  default     = "Average"
}

variable "threshold" {
  description = "The value against which the specified statistic is compared."
  type        = "string"
}

variable "unit" {
  description = "The unit for the alarm's associated metric"
  type        = "string"
  default     = ""
}