#!/usr/bin/env python3
"""Ingest a simulation file into a database."""

import argparse
import re
import sqlite3
import tarfile
import textwrap
from collections import namedtuple
from pathlib import Path

import pandas as pd
from Bio.SeqIO.FastaIO import SimpleFastaParser

Param = namedtuple('Param', 'field value')
Fasta = namedtuple('Fasta', 'name seq')

PARAM = re.compile(
    r' (\S+) \s+ \#+ \s+ \[ \d+ ] \s+ \[ (\w+) ] ',
    flags=re.VERBOSE)

DELETES = {
    'params': """delete from params where sim = ?""",
    'sites': """delete from sites where sim = ? and site = ?""",
    'trees': """delete from trees where sim = ? and site = ?""",
    'seqs': """delete from seqs where sim = ? and site = ? and species = ?""",
}


def ingest(args):
    """Ingest a simulation file into a database."""
    with tarfile.open(args.sim_file) as tar, sqlite3.connect(args.sqlite3) as cxn:
        for member in tar.getmembers():
            if not member.isreg():
                continue

            path = Path(member.name)

            sim = path.parts[0]
            site = path.parts[1]

            if path.suffix == '.txt':
                table = 'params'
                delete(cxn, table, (sim,))
                params = parse_params(tar, member)
                df = pd.DataFrame(params)
                insert_data(cxn, df, table, sim=sim)

            elif path.suffix == '.csv':
                table = 'sites'
                delete(cxn, table, (sim, site))
                df = pd.read_csv(tar.extractfile(member))
                insert_data(cxn, df, table, sim=sim, site=site)

            elif path.suffix == '.tre':
                table = 'trees'
                delete(cxn, table, (sim, site))
                with tar.extractfile(member) as in_file:
                    tree = in_file.read().decode().strip()
                df = pd.DataFrame({'tree': [tree]})
                insert_data(cxn, df, table, sim=sim, site=site)

            elif path.suffix == '.fasta':
                table = 'seqs'
                species = path.stem
                delete(cxn, table, (sim, site, species))
                seqs = parse_fasta(tar, member)
                df = pd.DataFrame(seqs)
                insert_data(cxn, df, table, sim=sim, site=site, species=species)


def insert_data(cxn, df, table, **kwargs):
    """Write the data frame to the data base."""
    for key, value in kwargs.items():
        df[key] = value
    df.to_sql(table, cxn, index=False, if_exists='append')


def delete(cxn, table, keys):
    """Delete existing records from the database."""
    sql = DELETES[table]
    try:
        cxn.execute(sql, keys)
    except sqlite3.OperationalError:
        pass


def parse_params(tar, member):
    """Get the simulation parameters."""
    params = []
    with tar.extractfile(member) as in_file:
        data = in_file.readlines()

    data = [ln.decode().strip() for ln in data]
    for ln in data:
        if match := PARAM.match(ln):
            params.append(Param(*match.group(2, 1)))

    return params


def parse_fasta(tar, member):
    """Parse a sequence file."""
    with tar.extractfile(member) as fasta_file:
        data = fasta_file.readlines()
        data = [ln.decode().strip() for ln in data]
        seqs = []
        for rec in SimpleFastaParser(data):
            if rec[1]:
                seqs.append(Fasta(rec[0], rec[1]))
    return seqs


def parse_command_line():
    """Process command-line arguments."""
    description = """
        Import a simulation into a database.
        """
    parser = argparse.ArgumentParser(
        fromfile_prefix_chars='@', description=textwrap.dedent(description))

    parser.add_argument(
        '--sim-file', '-s', required=True, type=Path,
        help="""Path to the simulation file.""")

    parser.add_argument(
        '--sqlite3', '-D', required=True, type=Path,
        help="""Path to the sqlite3 database.""")

    # parser.add_argument(
    #     '--tar', '-t', action='store_true',
    #     help="""Is the input simulation file tarred?""")

    args = parser.parse_args()

    return args


if __name__ == '__main__':
    ARGS = parse_command_line()
    ingest(ARGS)
