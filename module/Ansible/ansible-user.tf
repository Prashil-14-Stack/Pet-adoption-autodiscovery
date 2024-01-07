# Create IAM User
resource "aws_iam_user" "ansible_user" {
  name = "ansible_user"
}

# Create IAM Access Key
resource "aws_iam_access_key" "ansible_user_key" {
    user = aws_iam_user.ansible_user.name
}
# Create IAM Group
resource "aws_iam_group" "ansible_group" {
    name = "ansible_group"
}

# Add ansible user to ansible group
resource "aws_iam_user_group_membership" "ansible_group_membership" {
    user = aws_iam_user.ansible_user.name
    groups = [aws_iam_group.ansible_group.name]
}

resource "aws_iam_group_policy_attachment" "ansible_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    group = aws_iam_group.ansible_group.name
}