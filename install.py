#!/usr/bin/env python3
"""
Dotfiles Installation Script

This script installs dotfiles by creating symbolic links from the repository
to your home directory.
"""

import os
import sys
import argparse
from pathlib import Path
import shutil


class DotfilesInstaller:
    """Manages dotfiles installation and removal."""

    def __init__(self, repo_path, home_path=None, dry_run=False):
        """
        Initialize the installer.

        Args:
            repo_path: Path to the dotfiles repository
            home_path: Path to home directory (defaults to $HOME)
            dry_run: If True, only show what would be done
        """
        self.repo_path = Path(repo_path).resolve()
        self.home_path = Path(home_path or os.path.expanduser("~")).resolve()
        self.dry_run = dry_run

        # Define dotfile mappings: (source_dir, files)
        self.dotfile_mappings = {
            "bash": [".bashrc", ".bash_profile"],
            "git": [".gitconfig", ".gitignore_global"],
            "vim": [".vimrc"],
        }

    def install(self):
        """Install all dotfiles."""
        print("Installing dotfiles...")
        print(f"Repository: {self.repo_path}")
        print(f"Home: {self.home_path}")
        print()

        if self.dry_run:
            print("DRY RUN MODE - No changes will be made\n")

        for category, files in self.dotfile_mappings.items():
            source_dir = self.repo_path / category
            if not source_dir.exists():
                print(f"⚠️  Skipping {category}: directory not found")
                continue

            print(f"Installing {category} dotfiles:")
            for filename in files:
                source = source_dir / filename
                target = self.home_path / filename

                self._create_symlink(source, target)
            print()

        print("✓ Installation complete!")

    def uninstall(self):
        """Remove all dotfile symlinks."""
        print("Uninstalling dotfiles...")
        print(f"Home: {self.home_path}")
        print()

        if self.dry_run:
            print("DRY RUN MODE - No changes will be made\n")

        for category, files in self.dotfile_mappings.items():
            print(f"Removing {category} dotfiles:")
            for filename in files:
                target = self.home_path / filename
                self._remove_symlink(target)
            print()

        print("✓ Uninstallation complete!")

    def _create_symlink(self, source, target):
        """
        Create a symbolic link from source to target.

        Args:
            source: Source file path
            target: Target symlink path
        """
        if not source.exists():
            print(f"  ⚠️  {source.name}: source file not found")
            return

        if target.exists() or target.is_symlink():
            if target.is_symlink() and target.resolve() == source:
                print(f"  ✓ {target.name}: already linked")
                return
            else:
                # Backup existing file
                backup = target.parent / f"{target.name}.backup"
                print(f"  ⚠️  {target.name}: exists, backing up to {backup.name}")
                if not self.dry_run:
                    if backup.exists():
                        backup.unlink()
                    shutil.move(str(target), str(backup))

        print(f"  → {target.name}: linking")
        if not self.dry_run:
            target.symlink_to(source)

    def _remove_symlink(self, target):
        """
        Remove a symbolic link.

        Args:
            target: Target symlink path
        """
        if target.is_symlink():
            print(f"  → {target.name}: removing symlink")
            if not self.dry_run:
                target.unlink()
        elif target.exists():
            print(f"  ⚠️  {target.name}: exists but is not a symlink (skipping)")
        else:
            print(f"  ⚠️  {target.name}: not found (skipping)")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Install or uninstall dotfiles",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "action",
        choices=["install", "uninstall"],
        help="Action to perform",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes",
    )
    parser.add_argument(
        "--home",
        help="Home directory (defaults to $HOME)",
    )

    args = parser.parse_args()

    # Get repository path (parent directory of this script)
    repo_path = Path(__file__).parent.resolve()

    try:
        installer = DotfilesInstaller(
            repo_path=repo_path,
            home_path=args.home,
            dry_run=args.dry_run,
        )

        if args.action == "install":
            installer.install()
        elif args.action == "uninstall":
            installer.uninstall()

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
